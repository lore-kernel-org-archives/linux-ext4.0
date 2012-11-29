From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 29 Nov 2012 11:40:29 -0500
Message-ID: <20121129164029.GA16577@thunk.org>
References: <50A546D8.3020500@redhat.com>
 <20121129133129.GC20413@thunk.org>
 <50B77DB7.70307@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35813 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab2K2Qkd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 11:40:33 -0500
Content-Disposition: inline
In-Reply-To: <50B77DB7.70307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 29, 2012 at 09:22:31AM -0600, Eric Sandeen wrote:
> 
> But it's a weird inconsistency isn't it, and fixing it up in fsck should
> be the right thing to do anyway?

Oh, I agree, but basically, as a result I'm going to put this patch on
hold until we do a bit more testing.  I'm just not ready to push this
out on the maint branch just yet.....

(The general rule is that I want to keep the maint branch in a state
where someone who wants to take a snapshot for a production
environment should feel generally comfortable to do this --- modulo
rollout/integration testing, of course.  I'll keep it on an
es/fsck-int-node-fixup branch to make sure we don't lose it, but it's
something where I want to add some additional testing before I'm
comfortable rolling it out to the maint branch, just to make sure it
doesn't trigger any regression.)

BTW, while I was experimenting with test cases I found another related
bug (but not a regression) where e2fsck isn't able to fix up a
specific fs corruption (see attached).  It's unlikely to happen in
real life, but given how easily I was able to create something that
e2fsck can't fix, it's clear we were missing some synthetic test
cases.

						- Ted

--nFreZHaLTZJo0R7j
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bad-extent-no-fix.img.gz"
Content-Transfer-Encoding: base64

H4sICOKPt1ACA2JhZC1leHRlbnQtbm8tZml4LmltZwDt3EuMDFsYAOBTNS0mPcTjeo3364q4
DEEQEYJICAsJWzuExCsxIjeRGGsLkVhaWtlYig03N7m7KzaWVpbewsJKO6frjJ42JN5p+vuS
f+qf6ao+1dX1V53KVJ0QgG41McbBGGNirIlRi1GMnGF+FWm+cwdu7n146ebeEBqNfc+L5nzV
75Xh5fpiDMXYEGNbGcLfcfrf+hUz39Z3X7n8bM/d2+HsnQ/XY+XxE4M/+rP+f/HW450vtp+6
sOPe2F0vl/yb1ndcfu3sgdbn+J6Kj/wtbeMtdj06QE+MP2IsatZ/LZTNvXN4P31wxBaC31ej
0bhx4/qjZSl/0wC6SdnsAxflQJxWeVkODFR9+CmhXh47eXrwr8Mnz5w4WPWV7/f0FoOHTg8e
PnrskKMn/Nr6Pqj/1z1V/QNdomYTgPoH1D+g/gH1D6h/QP0D6h9Q/4D6B9Q/AADQiRoTPAMN
3ar+qj/sH3E8KIZCmByqcatSTAnVc8Epnxaq8YJSPiO0xgqbGaOe89l5mZTPjTE15/Pz8ilf
EGN6zhfm90r54hj9OV+S3zflS2PMyvmy3EbKl8eYk/OB3F7KV8WYl/PVue2Ur81tp3xdbjvl
60M1/lHKN+T1SPnGGH/mfFNep5RvdtrgN1F/Nb5j6n+6+gcAfoJ/tlYdhjT+73BUr5TNfkkI
vbmfVLT9mzSNhTbmO7R/7UL8cTWE87Hd4cg9sWZ/JbVfvG+/NZrw1C9oo5j2pM83DUD79f+4
99f/rrEBoFvO/2U8/4++rkx9gX6bBwAAAAAAAAB+KaPvf/85nqb772tV++33v/c0nztsv/+9
pQiGLePbDaXnL1bVaqP3/yLvf19vks3b8Tr5+Z9Tbce/Mrbf2iNn5enSEfmneP4HAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAD4HO8AUeso5gCQAQA=

--nFreZHaLTZJo0R7j--
