From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 1/11][take 2] add new mkfs option to create ext4 filesystems
Date: Thu, 21 Jun 2007 13:08:03 -0600
Message-ID: <20070621190803.GW5181@schatzie.adilger.int>
References: <467A936F.7030502@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43783 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXFUTIH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 15:08:07 -0400
Content-Disposition: inline
In-Reply-To: <467A936F.7030502@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:04 +0200, Valerie Clement wrote:
> @@ -1094,6 +1095,14 @@ static void PRS(int argc, char *argv[])
>  				exit(1);
>  			}
>  			break;
> +		case 'D':
> +			desc_size = strtoul(optarg, &tmp, 0);
> +			if (*tmp) {
> +				com_err(program_name, 0,
> +					_("invalid descriptor size - %s"), optarg);
> +				exit(1);
> +			}

I think we should limit the descriptor size to a power-of-two value so that
we can access it with only shift operations instead of division, and we do
not need to worry about descriptors crossing blocks.

Also, the upper limit should be the filesystem blocksize.

> @@ -1422,6 +1431,11 @@ static void PRS(int argc, char *argv[])
> +	if (desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
> +		fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
> +		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
> +	}

This should be "if (desc_size > EXT2_MIN_DESC_SIZE)" I think, even though
the two are (currently) equivalent.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
