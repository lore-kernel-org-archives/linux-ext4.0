From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Mon, 11 Feb 2013 09:56:12 -0600
Message-ID: <5119149C.1030602@redhat.com>
References: <20130207220536.GA16092@wallace> <20130208035547.GA19703@gmail.com> <20130211013523.GD10801@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab3BKP4G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:56:06 -0500
In-Reply-To: <20130211013523.GD10801@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/10/13 7:35 PM, Theodore Ts'o wrote:
> Here's the results of my xfstests run using "auto" on the kernel which
> includes all of the ext4 patches that were merged before 3.8-rc2.  (It
> doesn't include three fixup ext4 patches which got merged before
> 3.8-rc2 and 3.8-rc3.)  My goal is to make sure the patches I submit to
> Linus during the next merge window has no regressions compared to this
> xfstests run.

So the superset of failing tests seems to be:

223 270 274 280

223: file alignment tests (mkfs w/ stripe geom, check for allocation on stripe boundary)
- not critical, always been flaky AFAIK

270: stress fs at ENOSPC, check fs & quota consistency
- this one is a little worrisome, only failing on nodelalloc+noflexbg,
  but maybe that means "failing when running an ext3 filesystem?"

274: prealloc reservation test
- this fails because it's a diabolical test, with reservation into badly
  fragmented freespace, and there is not sufficient space reserved for
  metadata, so writes into prealloc'd space fails, breaking the fallocate
  guarantees.

280: Test quota vs. suspend/freeze deadlock
- If this is failing it's a regression, supposedly 
  dcdbed85 quota: Fix deadlock with suspend and quotas
  fixed this once already.

-Eric

> 						- Ted
> 
> [    0.000000] Linux version 3.8.0-rc1-00048-g7c8b4e6 (tytso@closure) (gcc version 4.7.1 (Debian 4.7.1-7) ) #668 SMP Sun Dec 30 13:27:49 EST 2012
> FSTESTCFG is "all"
> FSTESTSET is "-g auto"
> BEGIN TEST: Ext4 4k block Sun Dec 30 13:30:15 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 280 285
> Failures: 274 280
> END TEST: Ext4 4k block Sun Dec 30 15:13:45 EST 2012
> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Sun Dec 30 15:13:53 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 215 219 221 224 225 226 230 231 232 233 234 235 236 237 239 240 245 246 247 248 249 257 258 263 269 270 271 272 273 275 277 280 285
> Failures: 280
> END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Sun Dec 30 16:57:12 EST 2012
> BEGIN TEST: Ext4 4k block w/ no journal Sun Dec 30 16:57:14 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 285
> Failures: 274
> END TEST: Ext4 4k block w/ no journal Sun Dec 30 17:40:08 EST 2012
> BEGIN TEST: Ext4 1k block Sun Dec 30 17:40:13 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 280 285
> Failures: 274 280
> END TEST: Ext4 1k block Sun Dec 30 21:04:02 EST 2012
> BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Sun Dec 30 21:04:05 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 280 285
> Failures: 223 270 274 280
> END TEST: Ext4 4k block w/nodelalloc and no flex_bg Sun Dec 30 22:38:40 EST 2012
> BEGIN TEST: Ext4 4k block w/metadata_csum Sun Dec 30 22:38:43 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 280 285
> Failures: 274 280
> END TEST: Ext4 4k block w/metadata_csum Mon Dec 31 00:19:13 EST 2012
> BEGIN TEST: Ext4 4k block w/dioread_nolock Mon Dec 31 00:19:13 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 280 285
> Failures: 274 280
> END TEST: Ext4 4k block w/dioread_nolock Mon Dec 31 02:07:29 EST 2012
> BEGIN TEST: Ext4 4k block w/data=journal Mon Dec 31 02:07:34 EST 2012
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 068 069 070 074 075 076 079 083 088 089 091 100 105 112 113 117 120 123 124 125 126 127 128 129 130 131 132 133 135 141 169 184 192 193 198 204 207 208 209 210 211 212 213 214 215 219 221 223 224 225 226 228 230 231 232 233 234 235 236 237 239 240 243 245 246 247 248 249 255 256 257 258 263 269 270 271 272 273 274 275 277 280 285
> Failures: 223 274 280
> END TEST: Ext4 4k block w/data=journal Mon Dec 31 03:54:25 EST 2012
> BEGIN TEST: Ext4 4k block w/bigalloc Mon Dec 31 03:54:32 EST 2012
> 
> <end of test; as of 3.8-rc2, with bigalloc, the test run hangs with a
> huge number of errors spewed out to the console during xfstest #15.
> See the attached (compressed) log for more details>
> 

