import http from '@/utils/http.ts'

export async function getIpDetail() {
  return http({
    url: '/public/ip/detail',
    method: 'get'
  })
}

