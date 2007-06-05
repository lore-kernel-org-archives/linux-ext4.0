From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Tue, 5 Jun 2007 17:17:12 -0600
Message-ID: <20070605231712.GS5181@schatzie.adilger.int>
References: <4665479E.2060707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45810 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXFEXRP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 19:17:15 -0400
Content-Disposition: inline
In-Reply-To: <4665479E.2060707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 05, 2007  13:23 +0200, Karsten Hopp wrote:
> Attached is a patch to add cryptsetup-luks UUID detection in libblkid.so
> This is required when we want to use UUIDs instead of hardcoded device 
> names for
> encrypted partitions.
> 
> 
> +/* check it manually as using LUKS_read_phdr from libcryptsetup
> + * prints too many warnings if it isn't a luks partition and would add a
> + * dependency on the lib */

This is true of all superblock probing, so I'm not sure it deserves a
comment.

> +static int probe_luks(struct blkid_probe *probe,
> +		       struct blkid_magic *id __BLKID_ATTR((unused)), 
> +		       unsigned char *buf)
> +{
> +	const char *luks_magic = id->bim_magic;
> +	unsigned char *p_buf = buf;
> +	unsigned char uuid[40];
> +	if(strncmp(buf, luks_magic, strlen(luks_magic)) == 0)   /* ID matches, continue */
> +	{
> +	/* 168 is the offset to the 40 character uuid: http://luks.endorphin.org/LUKS-on-disk-format.pdf */
> +		p_buf += 168;
> +		strncpy(uuid, p_buf, 40);
> +		blkid_set_tag(probe->dev, "UUID", uuid, sizeof(uuid));
> +		blkid_set_tag(probe->dev, "SEC_TYPE", "crypt_LUKS", sizeof("crypt_LUKS"));

Please wrap lines at 80 columns.

Also, why use SEC_TYPE here?  That is "secondary type" and not (you
might think) "security type".  That should only be used if there are
two filesystem types that could mount the filesystem, and the SEC_TYPE
is the less-preferred one.

> @@ -775,6 +796,7 @@ static struct blkid_magic type_array[] =
>    { "ocfs2",	 2,	 0,  6,	"OCFSV2",		probe_ocfs2 },
>    { "ocfs2",	 4,	 0,  6,	"OCFSV2",		probe_ocfs2 },
>    { "ocfs2",	 8,	 0,  6,	"OCFSV2",		probe_ocfs2 },
> +  { "crypt_LUKS",		 0,	 0,	 6,	"LUKS\xba\xbe",			probe_luks },

Please fix the alignment here.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
