From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: fix memory leak in xattr code.
Date: Sun, 22 Sep 2013 15:33:35 -0400
Message-ID: <20130922193335.GA3797@thunk.org>
References: <20130920142918.GA21988@redhat.com>
 <523C69F7.4030903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <523C69F7.4030903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks, applied with a minor bug fix...

						- Ted

commit 8484764f97a840df851f4586079f28715f13318e
Author: Dave Jones <davej@redhat.com>
Date:   Sun Sep 22 15:31:00 2013 -0400

    ext4: fix memory leak in xattr
    
    If we take the 2nd retry path in ext4_expand_extra_isize_ea, we
    potentionally return from the function without having freed these
    allocations.  If we don't do the return, we over-write the previous
    allocation pointers, so we leak either way.
    
    Spotted with Coverity.
    
    [ Fixed by tytso to set is and bs to NULL after freeing these
      pointers, in case in the retry loop we later end up triggering an
      error causing a jump to cleanup, at which point we could have a double
      free bug. -- Ted ]
    
    Signed-off-by: Dave Jones <davej@fedoraproject.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c081e34..3c53192 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1350,6 +1350,9 @@ retry:
 				    s_min_extra_isize) {
 					tried_min_extra_isize++;
 					new_extra_isize = s_min_extra_isize;
+					kfree(is);
+					kfree(bs);
+					is = bs = NULL;
 					goto retry;
 				}
 				error = -1;
