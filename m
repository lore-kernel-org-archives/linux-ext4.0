From: "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 08/23] vfs: Add a flag to denote posix mapped richacl
Date: Mon, 1 Feb 2010 18:18:58 -0500
Message-ID: <20100201231858.GR19418@fieldses.org>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, adilger@sun.com, tytso@mit.edu, jlayton@redhat.com,
	nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org,
	sfrench@us.ibm.com, ffilz@us.ibm.com, linux-ext4@vger.kernel.org,
	agruen@suse.de
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <1265002505-8387-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

On Mon, Feb 01, 2010 at 11:04:50AM +0530, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/richacl_posix.c      |    7 +++++++
>  include/linux/richacl.h |   10 ++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
> index 07db970..3cf2124 100644
> --- a/fs/richacl_posix.c
> +++ b/fs/richacl_posix.c
> @@ -183,6 +183,13 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
>  	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
>  	acl->a_other_mask = richacl_mode_to_mask(mode);
>  
> +	/*
> +	 * Mark that the acl as mapped from posix
> +	 * This gives user space the chance to verify
> +	 * whether the mapping was correct
> +	 */

How would it use this information?  (And how could it be incorrect?)

--b.

> +	acl->a_flags |= ACL4_POSIX_MAPPED;
> +
>  	return;
>  }
>  
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index b08fdf1..41d93d8 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -36,12 +36,14 @@ struct richacl {
>  #define ACL4_AUTO_INHERIT		0x01
>  #define ACL4_PROTECTED			0x02
>  #define ACL4_DEFAULTED			0x04
> +#define ACL4_POSIX_MAPPED		0x10
>  #define ACL4_WRITE_THROUGH		0x40
>  
> -#define ACL4_VALID_FLAGS ( \
> -	ACL4_AUTO_INHERIT | \
> -	ACL4_PROTECTED | \
> -	ACL4_DEFAULTED | \
> +#define ACL4_VALID_FLAGS (	\
> +	ACL4_AUTO_INHERIT |	\
> +	ACL4_PROTECTED |	\
> +	ACL4_DEFAULTED |	\
> +	ACL4_POSIX_MAPPED |	\
>  	ACL4_WRITE_THROUGH)
>  
>  /* e_type values */
> -- 
> 1.7.0.rc0.48.gdace5
> 
