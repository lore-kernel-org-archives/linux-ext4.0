From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] e2fsck: fix incorrect interior node logical start
 values
Date: Mon, 24 Dec 2012 09:57:02 -0500
Message-ID: <20121224145702.GA10888@thunk.org>
References: <20121220234229.GA22476@thunk.org>
 <1356047023-28367-1-git-send-email-tytso@mit.edu>
 <50D4CAFE.5010606@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	forrestl@synology.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40137 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2LXO5J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Dec 2012 09:57:09 -0500
Content-Disposition: inline
In-Reply-To: <50D4CAFE.5010606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2012 at 02:47:58PM -0600, Eric Sandeen wrote:
> 
> Hm, this situation might still need more work in some cases.
> 
> but in this case, it seems that the length of the range covered by
> the previous interior nodes is still incorrect.  :(

Yep, we've got a problem which e2fsck is not detecting.  Here's a
simple test case which shows the problem:

debugfs:  extents <12>
Level Entries       Logical      Physical Length Flags
 0/ 2   1/  2     0 -     6    23              7
 1/ 2   1/  2     0 -     3    18              4
 2/ 2   1/  2     0 -     0    37 -    37      1 Uninit
 2/ 2   2/  2     2 -    21    50 -    69     20 Uninit <----- this conflicts
 1/ 2   2/  2     4 -     6    21              3        <----- with this
 2/ 2   1/  2     4 -     4    39 -    39      1 Uninit
 2/ 2   2/  2     6 -     6    40 -    40      1 Uninit
 0/ 2   2/  2     7 -    10    24              4
 1/ 2   1/  2     7 -     8    20              2
 2/ 2   1/  2     7 -     7    41 -    41      1 Uninit
 2/ 2   2/  2     8 -     8    42 -    42      1 Uninit
 1/ 2   2/  2     9 -    10    22              2
 2/ 2   1/  2     9 -     9    43 -    43      1 Uninit
 2/ 2   2/  2    10 -    10    44 -    44      1 Uninit

In this case it's not obvious what is the right fix, since we have two
physical blocks which claim to map to the same logical block.  There
are some places already in e2fsck where we today just throw up our
hands and offer to zap the entire inode, instead of trying to let the
user decide which is the correct physical blocks to use, or do some
way of saving out the conflicting inodes.  It may be that's the best
way to fix this, since at the very least should be detecting that
there is a problem, and fixing it somehow.  We can always try to come
up with a better way of repairing the corruption later.

Attached is a test case file system image with the above extent tree.

   	  	     		      - Ted


--oyUTqETQ0mS9luUI
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="leaf-node-overlap.img.gz"
Content-Transfer-Encoding: base64

H4sICPpq2FACA2xlYWYtbm9kZS1vdmVybGFwLmltZwDt3D1rU1EYAOCTm9SPtlCrqXYRLaX4
0VKlkyBF2sVBkIAKioNL6SBiBu3gVn9EfoEfiyL+gFLawcVBh4goFHFxFIc6iIPx3OSWpjUi
qJXYPA+8OSc3N7nJyXnPPYGcGwLQqfbEmInRFWM8RiFGrnmHw41I9ysuV0tfr78phVCrXfiU
q+/XuN+w9ryeGPMxTsWYTkK4kz73Rf/z95fPVypnKh8erDw5uPl9nJib2PLPeu3tu0sPn53t
qSy9fHTv6uOu9P32Zo8NLFRLW3HMXIttaRtP63q0gXyMfTGG6/lfCEm9d67106entRBsX7Va
Laz0fasdivUvNaCTJPU5cC5J5/6NepKMjzfm8MXQndwo37o9OlueuznTmCu/yudzs+WygRO2
gZ5N+f8538h/oEMUNAHIf0D+A/IfkP+A/AfkPyD/AfkPyH9A/gMA7ax7NQkXm+7n5kMYCY21
QMVYn8imB+n2I7HckdWPxnJnVj8Wy11Z/Xgsd2f10fT1s/qYpoa2U+uzBho6VfP53/kcOnf+
/7N5PrD98995Hjox/9evUru3aS4w0PS7oNg0RuzXbLDt8l+eAwAAAAAAAAAAAMD/YWChWlqL
f3ncj1OLk+lig+Hlamkoi3T74mS+fg2SdCVy+u/k7tXchsuUpdtctow/NX833pwsFH7s/7ms
//2+fs3b9pam0u+/1fiXhMFs/Aktxp/eGF1/4fj30/43FsLQpvEv7X/TG8a/JB5/vUceyMp0
zcZgU73V+o3X50au+KYBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAIBf+Q7vo/ruAJABAA==

--oyUTqETQ0mS9luUI--
