From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 2 Jun 2008 09:41:02 +0200
Message-ID: <20080602074102.GA3242@nb.net.home>
References: <1212171647.7508.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@Sun.COM>
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYFBHlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 03:41:06 -0400
Content-Disposition: inline
In-Reply-To: <1212171647.7508.46.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 30, 2008 at 07:20:47PM +0100, Ricardo M. Correia wrote:
> This patch adds ZFS filesystem detection to libblkid.

 It'd be nice to add ZFS detection to libvolume_id from udev package.

> Unfortunately the probe table doesn't support probing from the end of
> the device, otherwise we could also probe in the 3rd and 4th labels (in
> case the first 2 labels were accidentally overwritten)..

 This shouldn't be a problem in libvolume_id.

> +static int probe_zfs(struct blkid_probe *probe, struct blkid_magic *id,
> +		     unsigned char *buf)
> +{
> +	char *vdev_label;
> +	const char *pool_name = 0;
> +
> +	/* read nvpair data for pool name, pool GUID (complex) */
> +	//blkid_set_tag(probe->dev, "LABEL", pool_name, sizeof(pool_name));
> +	//set_uuid(probe->dev, pool_guid, 0);

 C++ ?

> -		if (memcmp(id->bim_magic, buf + (id->bim_sboff&0x3ff),
> +		if (memcmp(id->bim_magic, buf + (id->bim_sboff & 0x3ff),

 ???

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
