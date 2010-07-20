From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 00/16] New ACL format for better NFSv4 acl
	interoperability
Date: Tue, 20 Jul 2010 15:01:07 +0530
Message-ID: <m34ofucxes.fsf@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<201007192119.50868.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, adilger@sun.com, tytso@mit.edu, jlayton@redhat.com,
	staubach@redhat.com, bfields@citi.umich.edu, nfsv4@linux-nfs.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sfrench@us.ibm.com, ffilz@us.ibm.com, linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <201007192119.50868.agruen@suse.de>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 19 Jul 2010 21:19:50 +0200, Andreas Gruenbacher <agruen@suse.de> wrote:
> Aneesh,
> 
> here is a patch on top of the richacl-upstream queue.
> 
> So far, we were assuming that acls are always masked, and the file masks
> could be set so that they would not mask any permissions.  This is fine
> for permission checking, but richacl_apply_masks() didn't recognize when
> the file masks were set to mask nothing, and was still transforming such
> acls unnecessarily.  This could lead to correct but surprising results.
> 
> Instead of using a flag here we could check if the file masks are set to
> "ineffective" values, but that would require the same computation as
> richacl_compute_max_masks(), which can be a slow on large acls.  It is a
> lot easier to instead remember if the file masks are "effective".
> 
> (We still need to compute the file masks in nfsd where no file masks are
> supplied so that the file permission bits will be set to a reasonable
> value. user space will always pass valid file masks in, so we are covered
> in that side.)

We need to update ACL4_VALID_FLAGS to now consider ACL4_MASKED as a
valid flag. This is also needed for userspace. On a related note,
should we move ACL4_MASKED and ACL4_POSIX_MAPPED to be the higher
bits ? That would make sure we will be able to accomodate new flag
value NFSv4 define. Something like 

diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 929cc32..ff3c12b 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -50,16 +50,17 @@ struct richacl {
 /* a_flags values */
 #define ACL4_AUTO_INHERIT		0x01
 #define ACL4_PROTECTED			0x02
-/*#define ACL4_DEFAULTED			0x04*/
-#define ACL4_MASKED			0x08
-#define ACL4_POSIX_MAPPED		0x10
+#define ACL4_DEFAULTED			0x04
+/* flag value defined by Richacl */
+#define ACL4_MASKED			0x40
+#define ACL4_POSIX_MAPPED		0x80
 
 #define ACL4_VALID_FLAGS (	\
 	ACL4_AUTO_INHERIT |	\
 	ACL4_PROTECTED |	\
+	ACL4_MASKED |		\
 	ACL4_POSIX_MAPPED)
 
-
 /* e_type values */
 #define ACE4_ACCESS_ALLOWED_ACE_TYPE	0x0000
 #define ACE4_ACCESS_DENIED_ACE_TYPE	0x0001



-aneesh


_______________________________________________
NOTE: THIS LIST IS DEPRECATED.  Please use linux-nfs@vger.kernel.org instead.
(To subscribe to linux-nfs@vger.kernel.org: send "subscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org.)

NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
