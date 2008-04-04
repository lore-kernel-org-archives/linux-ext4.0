From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
Date: Fri, 04 Apr 2008 08:46:05 -0400
Message-ID: <1207313165.27710.337.camel@moss-spartans.epoch.ncsc.mil>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	 <6495.1207163569@turing-police.cc.vt.edu>
	 <20080402192715.GA32454@unused.rdu.redhat.com>
	 <20080402123905.386c56f8.akpm@linux-foundation.org>
	 <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0804041001410.23232@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <jbacik@redhat.com>, Valdis.Kletnieks@vt.edu,
	sct@redhat.com, jack@suse.cz, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, eparis@redhat.com
To: James Morris <jmorris@namei.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mummy.ncsc.mil ([144.51.88.129]:53260 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYDDMrM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2008 08:47:12 -0400
In-Reply-To: <Xine.LNX.4.64.0804041001410.23232@us.intercode.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Fri, 2008-04-04 at 10:02 +1100, James Morris wrote:
> On Thu, 3 Apr 2008, Stephen Smalley wrote:
> 
> > > > Try this patch, it will keep us from re-entering the fs when we aren't supposed
> > > > to.  cc'ing Eric Paris since he's the only selinux guy I know :).  I don't think
> 
> Please see the MAINTAINERS file.
> 
> > > > any of the other allocations in here need to be fixed, but I didn't look too
> > > > carefully.
> > > > 
> > > > Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> Thanks, I'll push this to Linus, but note that further analysis is 
> required.

Please review.

More cases where SELinux must not re-enter the fs code.
Called from the d_instantiate security hook.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

---

 security/selinux/hooks.c            |    7 ++++---
 security/selinux/include/security.h |    3 ++-
 security/selinux/ss/services.c      |   12 +++++++-----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 41a049f..95b51b6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1143,7 +1143,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		}
 
 		len = INITCONTEXTLEN;
-		context = kmalloc(len, GFP_KERNEL);
+		context = kmalloc(len, GFP_NOFS);
 		if (!context) {
 			rc = -ENOMEM;
 			dput(dentry);
@@ -1161,7 +1161,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			}
 			kfree(context);
 			len = rc;
-			context = kmalloc(len, GFP_KERNEL);
+			context = kmalloc(len, GFP_NOFS);
 			if (!context) {
 				rc = -ENOMEM;
 				dput(dentry);
@@ -1185,7 +1185,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			rc = 0;
 		} else {
 			rc = security_context_to_sid_default(context, rc, &sid,
-			                                     sbsec->def_sid);
+							     sbsec->def_sid,
+							     GFP_NOFS);
 			if (rc) {
 				printk(KERN_WARNING "%s:  context_to_sid(%s) "
 				       "returned %d for dev=%s ino=%ld\n",
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index f7d2f03..44e12ec 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -86,7 +86,8 @@ int security_sid_to_context(u32 sid, char **scontext,
 int security_context_to_sid(char *scontext, u32 scontext_len,
 	u32 *out_sid);
 
-int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *out_sid, u32 def_sid);
+int security_context_to_sid_default(char *scontext, u32 scontext_len,
+				    u32 *out_sid, u32 def_sid, gfp_t gfp_flags);
 
 int security_get_user_sids(u32 callsid, char *username,
 			   u32 **sids, u32 *nel);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f374186..3f2bad2 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -680,7 +680,8 @@ out:
 
 }
 
-static int security_context_to_sid_core(char *scontext, u32 scontext_len, u32 *sid, u32 def_sid)
+static int security_context_to_sid_core(char *scontext, u32 scontext_len,
+					u32 *sid, u32 def_sid, gfp_t gfp_flags)
 {
 	char *scontext2;
 	struct context context;
@@ -709,7 +710,7 @@ static int security_context_to_sid_core(char *scontext, u32 scontext_len, u32 *s
 	   null suffix to the copy to avoid problems with the existing
 	   attr package, which doesn't view the null terminator as part
 	   of the attribute value. */
-	scontext2 = kmalloc(scontext_len+1,GFP_KERNEL);
+	scontext2 = kmalloc(scontext_len+1, gfp_flags);
 	if (!scontext2) {
 		rc = -ENOMEM;
 		goto out;
@@ -809,7 +810,7 @@ out:
 int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
-	                                    sid, SECSID_NULL);
+					    sid, SECSID_NULL, GFP_KERNEL);
 }
 
 /**
@@ -829,10 +830,11 @@ int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
  * Returns -%EINVAL if the context is invalid, -%ENOMEM if insufficient
  * memory is available, or 0 on success.
  */
-int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *sid, u32 def_sid)
+int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *sid,
+				    u32 def_sid, gfp_t gfp_flags)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
-	                                    sid, def_sid);
+					    sid, def_sid, gfp_flags);
 }
 
 static int compute_sid_handle_invalid_context(

-- 
Stephen Smalley
National Security Agency

