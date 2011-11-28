From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] tests: add test case for multiply claimed blocks with bigalloc
Date: Mon, 28 Nov 2011 12:15:44 -0500
Message-ID: <1322500544-21022-2-git-send-email-tytso@mit.edu>
References: <20111128170225.GA4348@thunk.org>
 <1322500544-21022-1-git-send-email-tytso@mit.edu>
Cc: hao.bigrat@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54248 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1K1RPv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 12:15:51 -0500
In-Reply-To: <1322500544-21022-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_dup_ba/expect.1 |   69 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/f_dup_ba/expect.2 |    7 +++++
 tests/f_dup_ba/image.gz |  Bin 0 -> 4668 bytes
 tests/f_dup_ba/name     |    1 +
 4 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 tests/f_dup_ba/expect.1
 create mode 100644 tests/f_dup_ba/expect.2
 create mode 100644 tests/f_dup_ba/image.gz
 create mode 100644 tests/f_dup_ba/name

diff --git a/tests/f_dup_ba/expect.1 b/tests/f_dup_ba/expect.1
new file mode 100644
index 0000000..f0ad457
--- /dev/null
+++ b/tests/f_dup_ba/expect.1
@@ -0,0 +1,69 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 16, i_size is 8192, should be 409600.  Fix? yes
+
+Inode 16, i_blocks is 128, should be 896.  Fix? yes
+
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 16: 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239
+Multiply-claimed block(s) in inode 17: 160 161
+Multiply-claimed block(s) in inode 18: 176 177
+Multiply-claimed block(s) in inode 19: 192 193
+Multiply-claimed block(s) in inode 20: 208 209
+Multiply-claimed block(s) in inode 21: 224 225
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 6 inodes containing multiply-claimed blocks.)
+
+File /5 (inode #16, mod time Sun Nov 27 04:39:31 2011) 
+  has 5 multiply-claimed block(s), shared with 5 file(s):
+	/10 (inode #21, mod time Sun Nov 27 04:39:36 2011)
+	/9 (inode #20, mod time Sun Nov 27 04:39:35 2011)
+	/8 (inode #19, mod time Sun Nov 27 04:39:34 2011)
+	/7 (inode #18, mod time Sun Nov 27 04:39:33 2011)
+	/6 (inode #17, mod time Sun Nov 27 04:39:32 2011)
+Clone multiply-claimed blocks? yes
+
+File /6 (inode #17, mod time Sun Nov 27 04:39:32 2011) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/5 (inode #16, mod time Sun Nov 27 04:39:31 2011)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /7 (inode #18, mod time Sun Nov 27 04:39:33 2011) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/5 (inode #16, mod time Sun Nov 27 04:39:31 2011)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /8 (inode #19, mod time Sun Nov 27 04:39:34 2011) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/5 (inode #16, mod time Sun Nov 27 04:39:31 2011)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /9 (inode #20, mod time Sun Nov 27 04:39:35 2011) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/5 (inode #16, mod time Sun Nov 27 04:39:31 2011)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /10 (inode #21, mod time Sun Nov 27 04:39:36 2011) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/5 (inode #16, mod time Sun Nov 27 04:39:31 2011)
+Multiply-claimed blocks already reassigned or cloned.
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +240
+Fix? yes
+
+Free blocks count wrong for group #0 (49, counted=43).
+Fix? yes
+
+Free blocks count wrong (784, counted=688).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 21/64 files (0.0% non-contiguous), 336/1024 blocks
+Exit status is 1
diff --git a/tests/f_dup_ba/expect.2 b/tests/f_dup_ba/expect.2
new file mode 100644
index 0000000..ec04450
--- /dev/null
+++ b/tests/f_dup_ba/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 21/64 files (4.8% non-contiguous), 336/1024 blocks
+Exit status is 0
diff --git a/tests/f_dup_ba/image.gz b/tests/f_dup_ba/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..4b318638b917583b3613f78bc6aac6b5e4e2f6ef
GIT binary patch
literal 4668
zc-oWi=3r=Jz3j)t{PxD#?2vE?_6NoOi+qiPjW?FAjaVz+xH2%>KJ24>N7D7C1Oe8-
zg`v}Z7uGuzCN5m9x9R1%)bLk+cV_lxo9nq8Z58AaJyxFfPITe|_diV^D<ABAe{yf}
zbMx;$7I&;Q8RxIw`7h08sqICpWX-czeivW4budF|>CuO;|LxyqbAQ)9oA{-1@0TAB
zU6pkI@{Q|z!b87@NzIwG&0V(FeAS|5{l5P#|K5N2*L(ZEnBw=R?5D^5mAM}uWASm}
z`mg5>FP-}B@Xq@B_{y@+58fS~{(JuRSo!LoR`-@?O|3P&`*KUYEdzsH<G<Q}zgC<L
z++6s5K709c1_p)$8ZZAwl>-?GDL+|R7{~?<LVNEW+r<oIEk32MK)yK)dwQ2&pZ0wA
zuNgc0`Hn6#J~MxZ-I|9JH*T?bA)INnZL<F=lYf^gL$Bz?OMl?Y`*MB$&a2n<|4I7m
zxq6NL<HMKl-Mo~)@utYt`0uk;h3`<?AEj!4{Gf8H<m~tVzdrE&8T!O5bXNTyga5ai
z{>bd~o%(FP{+ath6YRx6Y<;n3`F|OHatGFnJgX0%U@r$0jQfAT_2+G_PuE@Yf|vdb
z=l;B1{K@*>JIlO2=ZidhuW{nPQqgR!v-@Lb?BA@gf9LmE72SV!xBfI<f0CUXzq^I^
zWi8h#kMAjdcT9e*MEzv7&ohhd{~Hy5y3@Lu`)_jd^{~ws_pds>d-3|!$Ez3lUwypy
zqV?Aw?Jq8W{c-%o>(?Lmy@<d5_;2%`hd&&?@CGhlR%E*SbU6jF3IZPtw=BA~^3>fI
zmRYG<&-1SD0i~J~FJ~};<o@sj$%=nu__pDCw(Hj5sk<*0UpW<W?(VuuMxfZl%Z98#
uxd%Vx;f9ZbQ7{Td!6+C7qhJ(_f>AIEM!_f;1p@@W*s_Nl(F1m?9T)(+mS8Uc

literal 0
Hc-jL100001

diff --git a/tests/f_dup_ba/name b/tests/f_dup_ba/name
new file mode 100644
index 0000000..a1a8b80
--- /dev/null
+++ b/tests/f_dup_ba/name
@@ -0,0 +1 @@
+multiply claimed blocks with bigalloc
-- 
1.7.4.1.22.gec8e1.dirty

