From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: what are possible causes of "zero length extent" ?
Date: Fri, 1 Jul 2016 11:52:33 -0400
Message-ID: <20160701155233.GA11237@thunk.org>
References: <FE37120F1498264DADC12DBE984882149659843D@EU-MBX-01.mgc.mentorg.com>
 <FE37120F1498264DADC12DBE98488214965A2601@EU-MBX-01.mgc.mentorg.com>
 <FE37120F1498264DADC12DBE98488214990390F4@EU-MBX-01.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: "Craske, Mark" <Mark_Craske@mentor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36408 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbcGAPwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2016 11:52:37 -0400
Content-Disposition: inline
In-Reply-To: <FE37120F1498264DADC12DBE98488214990390F4@EU-MBX-01.mgc.mentorg.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 01, 2016 at 02:08:09PM +0000, Craske, Mark wrote:
> Hello Ted and Andreas,
> 
> Is https://github.com/torvalds/linux/commit/d2dc317d564a46dfc683978a2e5a4f91434e9711
> "ext4: fix data corruption caused by unwritten and delayed extents"
> a fix for one of the causes of "zero length extent"?

I wouldn't know.  Sorry for not responding to you, but "zero length
extent" doesn't really ring a bell.  I can say that tests using
3.18.26 were running pretty clean for me:

Ran: ext4/001 ext4/002 ext4/003 ext4/004 ext4/005 ext4/271 ext4/301 ext4/302 ext4/303 ext4/304 ext4/305 ext4/306 ext4/307 ext4/308 generic/001 generic/002 generic/003 generic/004 generic/005 generic/006 generic/007 generic/008 generic/009 generic/011 generic/012 generic/013 generic/014 generic/015 generic/016 generic/017 generic/018 generic/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic/027 generic/028 generic/029 generic/030 generic/031 generic/032 generic/033 generic/034 generic/035 generic/036 generic/037 generic/039 generic/040 generic/041 generic/053 generic/056 generic/057 generic/059 generic/062 generic/065 generic/066 generic/067 generic/068 generic/069 generic/070 generic/071 generic/072 generic/073 generic/074 generic/075 generic/076 generic/077 generic/0
 78 generic/079 generic/080 generic/081 generic/082 generic/083 generic/084 generic/085 generic/086 generic/087 generic/088 generic/089 generic/090 generic/091 generic/092 generic/094 generic/095 generic/096 generic/098 generic/100 generic/101 generic/102 generic/103 generic/104 generic/105 generic/106 generic/107 generic/109 generic/112 generic/113 generic/114 generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/177 generic/184 generic/192 generic/193 generic/198 generic/204 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/219 generic/221 generic/224 generic/225 generic/226 gen
 eric/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/236 generic/237 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 generic/257 generic/258 generic/260 generic/263 generic/269 generic/270 generic/273 generic/274 generic/275 generic/277 generic/280 generic/285 generic/286 generic/288 generic/294 generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 generic/310 generic/311 generic/312 generic/313 generic/314 generic/315 generic/316 generic/319 generic/320 generic/321 generic/322 generic/323 generic/324 generic/325 shared/001 shared/003 shared/006 shared/272 shared/289 shared/298
Not run: generic/010 generic/026 generic/038 generic/043 generic/044 generic/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic/051 generic/052 generic/054 generic/055 generic/058 generic/060 generic/061 generic/063 generic/064 generic/093 generic/097 generic/099 generic/108 generic/110 generic/111 generic/115 generic/116 generic/118 generic/119 generic/121 generic/122 generic/134 generic/136 generic/137 generic/138 generic/139 generic/140 generic/142 generic/143 generic/144 generic/145 generic/146 generic/147 generic/148 generic/149 generic/150 generic/151 generic/152 generic/153 generic/154 generic/155 generic/156 generic/157 generic/158 generic/159 generic/160 generic/161 generic/162 generic/163 generic/164 generic/165 generic/166 generic/167 generic/168 generic/170
  generic/171 generic/172 generic/173 generic/174 generic/178 generic/179 generic/180 generic/181 generic/182 generic/183 generic/185 generic/186 generic/187 generic/188 generic/189 generic/190 generic/191 generic/194 generic/195 generic/196 generic/197 generic/199 generic/200 generic/201 generic/202 generic/203 generic/205 generic/206 generic/216 generic/217 generic/218 generic/220 generic/222 generic/227 generic/229 generic/238 generic/242 generic/243 generic/244 generic/317 generic/318 shared/002 shared/032 shared/051
Failures: ext4/001 ext4/304 generic/313
Failed 3 of 196 tests

This was on an x86 system.  If you want to do your own testing on ARM,
there is an alpha-test tarball here that might be worth trying.

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/testing/

If this doesn't help, you'll need to give a much more concrete
replication, preferably on x86, before the upstream developers are
likely to be able to help --- and even then, we generally don't
support legacy, downrev kernels.  (Especially since very often the SOC
vendors have done severe hackery on their BSP kernels, and they don't
bother to take bug fixes from the upstream stable kernels.  So if they
can't even meet us half way, then you really need to be complaining to
them....)

						- Ted
