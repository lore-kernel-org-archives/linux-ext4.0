From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH RFC 00/13] UTF-8 case insensitive lookups for EXT4
Date: Fri, 12 Jan 2018 08:56:57 -0800
Message-ID: <20180112165657.GB208915@jra3>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112071234.29470-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 12, 2018 at 05:12:21AM -0200, Gabriel Krisman Bertazi wrote:
> Hi,
> 
> In the past few months, I've been working to support case-insensitive
> lookups of utf8 encoded strings, primarily for EXT4, and then for other
> filesystems.  This RFC uses the awesome UTF8 normalization
> implementation done by the SGI guys in 2014, namely Olaf Weber and Ben
> Myers, but it, unfortunately, never went upstream.  That SGI effort was
> made of 3 versions of an RFC submitted to this list, and the last
> version was archived below:

Just want to say thanks a *LOT* for this work. It would significantly
help Samba and Windows interop. Now if we can only get the RichACL
patch into the kernel.... :-).

Cheers,

	Jeremy.
