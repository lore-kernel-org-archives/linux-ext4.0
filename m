From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Wed, 27 Aug 2008 10:32:52 +0200
Message-ID: <20080827083252.GP6029@nb.net.home>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home> <20080826233224.GB29936@mit.edu> <20080827001942.GN6029@nb.net.home> <20080827012121.GD29936@mit.edu> <20080827044054.GE29936@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbYH0Ic6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2008 04:32:58 -0400
Content-Disposition: inline
In-Reply-To: <20080827044054.GE29936@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2008 at 12:40:54AM -0400, Theodore Tso wrote:
> > I think we can ignore this minor problem for now. I'll try to found a
> > better solution for dependencies resolution without libdevmapper. My
> > wish is to avoid libdevmapper in libfsprobe.
> 
> Here's a patch that I've been working on which gives a priority bonus
> to dm leaf devices, without needing libdevmapper.  As I've mentioned
> before, I'm not 100% convinced this is always the right thing.  But
> it's probably a not-half-bad hueristic...
[...]
>  
> +static int is_dm_leaf(const char *devname)
> +{
> +	struct dirent	*de, *d_de;
> +	DIR		*dir, *d_dir;
> +	char		path[256];
> +	int		ret = 1;
> +
> +	if ((dir = opendir("/sys/block")) == NULL)
> +		return 0;
> +	while ((de = readdir(dir)) != NULL) {
> +		if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..") ||
> +		    !strcmp(de->d_name, devname) ||
> +		    strncmp(de->d_name, "dm-", 3) ||
> +		    strlen(de->d_name) > sizeof(path)-32)
> +			continue;
> +		sprintf(path, "/sys/block/%s/slaves", de->d_name);
> +		if ((d_dir = opendir(path)) == NULL)
> +			continue;
> +		while ((d_de = readdir(d_dir)) != NULL) {
> +			if (!strcmp(d_de->d_name, devname)) {
> +				ret = 0;
> +				break;
> +			}
> +		}
> +		closedir(d_dir);
> +		if (!ret)
> +			break;
> +	}
> +	closedir(dir);
> +	return ret;
> +}

 Seems good. This patch and the brute-force for conversion from dm-N to
 real names is the way how replace the HAVE_DEVMAPPER crap in libblkid.
 Thanks!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
