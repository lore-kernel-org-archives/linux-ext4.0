From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Mon, 21 Mar 2011 20:05:37 +0100
Message-ID: <201103212005.37108.arnd@arndb.de>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <AANLkTik0DkQa7NrGbpSVVAkhQ4O9+kenPSr2dP=+Ej94@mail.gmail.com> <C0A67981-AF1A-40FF-91BA-93ECF6F72B58@dilger.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrei Warkentin <andreiw@motorola.com>, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <C0A67981-AF1A-40FF-91BA-93ECF6F72B58@dilger.ca>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 21 March 2011 19:03:09 Andreas Dilger wrote:
> Note that mballoc was specifically designed to handle allocation
> requests that are aligned on RAID stripe boundaries, so it should
> be able to handle this for MMC as well.  What is needed is to tell
> the filesystem what the underlying alignment is.  That can be done
> at format time with mke2fs or afterward with tune2fs by using the
> "-E stripe_width" option.

Ah, that sounds useful. So would I set the stripe_width to the
erase block size, and the block group size to a multiple of that?

Does this also work in (rare) cases where the erase block size is
not a power of two?

	Arnd
