From: "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 16/23] ext4: Update richacl incompat flag value
Date: Mon, 1 Feb 2010 18:41:30 -0500
Message-ID: <20100201234130.GW19418@fieldses.org>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
In-Reply-To: <1265002505-8387-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

On Mon, Feb 01, 2010 at 11:04:58AM +0530, Aneesh Kumar K.V wrote:
> Update the incompat flag value so that we don't
> conflict with ext4 features which are not yet
> upstream but are in use.

In general, for any patches that just fix problems in preceding patches,
could you just fold those into the preceding patches?

--b.

> 
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/ext4.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 13df624..bcbff59 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1133,7 +1133,9 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
>  #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
>  #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
> -#define EXT4_FEATURE_INCOMPAT_RICHACL		0x0400
> +#define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
> +#define EXT4_FEATURE_INCOMPAT_RICHACL		0x0800
> +#define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
>  
>  #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
>  #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
> -- 
> 1.7.0.rc0.48.gdace5
> 
