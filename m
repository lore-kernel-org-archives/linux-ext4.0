From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Fri, 24 Sep 2010 11:03:51 -0600
Message-ID: <F2605A93-6209-4A10-A444-E936FE7B882D@dilger.ca>
References: <1285342559-16424-1-git-send-email-lczerner@redhat.com> <1285342559-16424-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63155 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab0IXRDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2010 13:03:53 -0400
In-Reply-To: <1285342559-16424-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-24, at 09:35, Lukas Czerner wrote:
> array[0] - (start) first Byte to trim
> array[1] - (len) number of Bytes to trim from start
> array[2] - (minlen) minimum extent length to trim, free extents shorter
> 
> than this number of Bytes will be ignored. This number will be rounded
> up to the block size.
> 
> It is also possible to specify NULL as an argument. In this case the
> arguments will set itself as follows:
> 
> args[0] = 0;
> args[1] = ULLONG_MAX;
> args[2] = 0;

(minor) you use "array[]" in one place and "args[]" in another.

> +#define FITRIM		_IOWR('X', 121, uint64_t)	/* Trim */

This ioctl definition isn't strictly correct.  The "size" parameter is actually uint64_t[3], though I'm not sure whether you need to define a structure in order to specify this.

Cheers, Andreas





