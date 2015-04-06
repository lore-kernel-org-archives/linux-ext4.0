From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 06/22] ext4 crypto: add encryption policy checking
Date: Mon, 6 Apr 2015 15:31:49 -0600
Message-ID: <6C2E40F9-574A-4EA8-B533-C9D8CCF1C9C3@dilger.ca>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu> <1428012659-12709-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <muslukhovi@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36027 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbbDFVb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2015 17:31:56 -0400
Received: by pdea3 with SMTP id a3so56565921pde.3
        for <linux-ext4@vger.kernel.org>; Mon, 06 Apr 2015 14:31:56 -0700 (PDT)
In-Reply-To: <1428012659-12709-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> From: Michael Halcrow <mhalcrow@google.com>
> 
> The ext4_crypto.h header will get fleshed out as later patches in this
> patchset add functionality.
> 
> Change-Id: I550d197184af04ed27e4c3abb759ca188a3f0de0
> Signed-off-by: Michael Halcrow <mhalcrow@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Ildar Muslukhov <muslukhovi@gmail.com>
> ---
> fs/ext4/Makefile        |   1 +
> fs/ext4/crypto_policy.c | 155 ++++++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/ext4.h          |   2 +
> fs/ext4/ext4_crypto.h   |  54 +++++++++++++++++
> 4 files changed, 212 insertions(+)
> create mode 100644 fs/ext4/crypto_policy.c
> create mode 100644 fs/ext4/ext4_crypto.h
> 
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index cd6f50f..3886ee4 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -12,3 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
> 
> ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
> ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
> +ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o
> diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
> new file mode 100644
> index 0000000..5cb4e74
> --- /dev/null
> +++ b/fs/ext4/crypto_policy.c
> @@ -0,0 +1,155 @@
> +/*
> + * linux/fs/ext4/crypto_policy.c
> + *
> + * This contains encryption policy functions for ext4
> + *
> + * Written by Michael Halcrow, 2015.
> + */
> +
> +#include <linux/random.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +#include "ext4.h"
> +#include "xattr.h"
> +
> +/**
> + * ext4_to_hex() - Converts to hexadecimal characters
> + * @dst: Buffer to take hex character representation of contents of
> + *       src. Must be at least of size (src_size * 2).
> + * @src: Buffer to be converted to a hex string respresentation.
> + * @src_size: Number of bytes to convert.
> + */
> +void ext4_to_hex(char *dst, char *src, size_t src_size)
> +{
> +	int x;
> +
> +	for (x = 0; x < src_size; x++)
> +		sprintf(&dst[x * 2], "%.2x", (unsigned char)src[x]);
> +}

I think there is already some code in printk() to handle this?  Looking
at vsnprintf->hex_string() it looks like "%*ph" would print out up to 64
bytes as hex.

Cheers, Andreas

> +
> +/**
> + *
> + */
> +static int ext4_inode_has_encryption_context(struct inode *inode)
> +{
> +	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, NULL, 0);
> +	return (res > 0);
> +}
> +
> +/**
> + * ext4_is_encryption_context_consistent_with_policy() - Checks whether the policy is consistent with the encryption context for the inode
> + * @inode:  ...
> + * @policy: ...
> + *
> + * Return ...
> + */
> +static int ext4_is_encryption_context_consistent_with_policy(
> +	struct inode *inode, const struct ext4_encryption_policy *policy)
> +{
> +	struct ext4_encryption_context ctx;
> +	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, &ctx,
> +				 sizeof(ctx));
> +	if (res != sizeof(ctx))
> +		return 0;
> +	return (memcmp(ctx.master_key_descriptor, policy->master_key_descriptor,
> +			EXT4_KEY_DESCRIPTOR_SIZE) == 0 &&
> +		(ctx.contents_encryption_mode ==
> +		 policy->contents_encryption_mode) &&
> +		(ctx.filenames_encryption_mode ==
> +		 policy->filenames_encryption_mode));
> +}
> +
> +static int ext4_create_encryption_context_from_policy(
> +	struct inode *inode, const struct ext4_encryption_policy *policy)
> +{
> +	struct ext4_encryption_context ctx;
> +	int res = 0;
> +
> +	ctx.format = EXT4_ENCRYPTION_CONTEXT_FORMAT_V0;
> +	memcpy(ctx.master_key_descriptor, policy->master_key_descriptor,
> +	       EXT4_KEY_DESCRIPTOR_SIZE);
> +	ctx.contents_encryption_mode = policy->contents_encryption_mode;
> +	ctx.filenames_encryption_mode = policy->filenames_encryption_mode;
> +	BUILD_BUG_ON(sizeof(ctx.nonce) != EXT4_KEY_DERIVATION_NONCE_SIZE);
> +	get_random_bytes(ctx.nonce, EXT4_KEY_DERIVATION_NONCE_SIZE);
> +
> +	res = ext4_xattr_set(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, &ctx,
> +			     sizeof(ctx), 0);
> +	if (!res)
> +		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> +	return res;
> +}
> +
> +int ext4_process_policy(const struct ext4_encryption_policy *policy,
> +			struct inode *inode)
> +{
> +	int res = 0;
> +
> +	if (!ext4_inode_has_encryption_context(inode)) {
> +		res = ext4_create_encryption_context_from_policy(inode, policy);
> +		goto out;
> +	}
> +
> +	if (!ext4_is_encryption_context_consistent_with_policy(inode, policy)) {
> +		printk(KERN_WARNING
> +		       "%s: Policy inconsistent with encryption context\n",
> +		       __func__);
> +		res = -EINVAL;
> +	}
> +out:
> +	return res;
> +}
> +
> +int ext4_is_child_context_consistent_with_parent(struct inode *parent,
> +						 struct inode *child)
> +{
> +	struct ext4_encryption_context parent_ctx, child_ctx;
> +	int res = ext4_xattr_get(parent, EXT4_XATTR_INDEX_ENCRYPTION,
> +				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +				 &parent_ctx, sizeof(parent_ctx));
> +
> +	if (res != sizeof(parent_ctx))
> +		return 0;
> +	res = ext4_xattr_get(parent, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +			     &child_ctx, sizeof(child_ctx));
> +	if (res != sizeof(child_ctx))
> +		return 0;
> +	return (memcmp(parent_ctx.master_key_descriptor,
> +		       child_ctx.master_key_descriptor,
> +		       EXT4_KEY_DESCRIPTOR_SIZE) == 0 &&
> +		(parent_ctx.contents_encryption_mode ==
> +		 child_ctx.contents_encryption_mode) &&
> +		(parent_ctx.filenames_encryption_mode ==
> +		 child_ctx.filenames_encryption_mode));
> +}
> +
> +/**
> + * ext4_inherit_context() - Sets a child context from its parent
> + * @parent: Parent inode from which the context is inherited.
> + * @child:  Child inode that inherits the context from @parent.
> + *
> + * Return: Zero on success, non-zero otherwise
> + */
> +int ext4_inherit_context(struct inode *parent, struct inode *child)
> +{
> +	struct ext4_encryption_context ctx;
> +	int res = ext4_xattr_get(parent, EXT4_XATTR_INDEX_ENCRYPTION,
> +				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +				 &ctx, sizeof(ctx));
> +
> +	if (res != sizeof(ctx))
> +		return -ENOENT;
> +
> +	get_random_bytes(ctx.nonce, EXT4_KEY_DERIVATION_NONCE_SIZE);
> +	res = ext4_xattr_set(child, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, &ctx,
> +			     sizeof(ctx), 0);
> +	if (!res)
> +		ext4_set_inode_flag(child, EXT4_INODE_ENCRYPT);
> +	return res;
> +}
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2f3808e..fd2f3dd 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -588,6 +588,8 @@ enum {
> #define EXT4_ENCRYPTION_MODE_AES_256_GCM	2
> #define EXT4_ENCRYPTION_MODE_AES_256_CBC	3
> 
> +#include "ext4_crypto.h"
> +
> /*
>  * ioctl commands
>  */
> diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
> new file mode 100644
> index 0000000..984ff38
> --- /dev/null
> +++ b/fs/ext4/ext4_crypto.h
> @@ -0,0 +1,54 @@
> +/*
> + * linux/fs/ext4/ext4_crypto.h
> + *
> + * This contains encryption header content for ext4
> + *
> + * Written by Michael Halcrow, 2015.
> + */
> +
> +#ifndef _EXT4_CRYPTO_H
> +#define _EXT4_CRYPTO_H
> +
> +#include <linux/fs.h>
> +
> +#define EXT4_KEY_DESCRIPTOR_SIZE 8
> +
> +/* Policy provided via an ioctl on the topmost directory */
> +struct ext4_encryption_policy {
> +	char version;
> +	char contents_encryption_mode;
> +	char filenames_encryption_mode;
> +	char master_key_descriptor[EXT4_KEY_DESCRIPTOR_SIZE];
> +} __attribute__((__packed__));
> +
> +#define EXT4_ENCRYPTION_CONTEXT_FORMAT_V0 0
> +#define EXT4_KEY_DERIVATION_NONCE_SIZE 16
> +
> +/**
> + * Encryption context for inode
> + *
> + * Protector format:
> + *  1 byte: Protector format (0 = this version)
> + *  1 byte: File contents encryption mode
> + *  1 byte: File names encryption mode
> + *  1 byte: Reserved
> + *  8 bytes: Master Key descriptor
> + *  16 bytes: Encryption Key derivation nonce
> + */
> +struct ext4_encryption_context {
> +	char format;
> +	char contents_encryption_mode;
> +	char filenames_encryption_mode;
> +	char reserved;
> +	char master_key_descriptor[EXT4_KEY_DESCRIPTOR_SIZE];
> +	char nonce[EXT4_KEY_DERIVATION_NONCE_SIZE];
> +} __attribute__((__packed__));
> +
> +int ext4_is_child_context_consistent_with_parent(struct inode *parent,
> +						 struct inode *child);
> +int ext4_inherit_context(struct inode *parent, struct inode *child);
> +void ext4_to_hex(char *dst, char *src, size_t src_size);
> +int ext4_process_policy(const struct ext4_encryption_policy *policy,
> +			struct inode *inode);
> +
> +#endif	/* _EXT4_CRYPTO_H */
> -- 
> 2.3.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





