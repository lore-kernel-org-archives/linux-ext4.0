From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] jbd2: Fix block tag checksum verification brokenness
Date: Thu, 9 May 2013 00:03:39 +0100
Message-ID: <20130508230339.GC25399@ZenIV.linux.org.uk>
References: <20130508220027.GB7730@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59692 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3EHXDn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 19:03:43 -0400
Content-Disposition: inline
In-Reply-To: <20130508220027.GB7730@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 08, 2013 at 03:00:27PM -0700, Darrick J. Wong wrote:
> +	crc = csum32 & 0xFFFF;
>  
> -	tag->t_checksum = cpu_to_be32(csum);
> +	tag->t_checksum = cpu_to_be16(crc);

Simple cpu_to_be16(csum) will do - it'll convert the argument to __u16,
which will do exactly the same thing your & 0xFFFF is doing.  Matter of
taste...

> +	crc = csum32 & 0xFFFF;
> +	provided = be16_to_cpu(tag->t_checksum);
>  
> -	return provided == cpu_to_be32(calculated);
> +	return provided == crc;

I'd go for tag->t_checksum == cpu_to_be16(calculated) - less cluttered that
way, IMO.  Again, a matter of taste.  ACK, as far as correctness is concerned.
