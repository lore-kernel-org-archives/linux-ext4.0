From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 32/32] ext4: add nombcache mount option
Date: Thu, 22 Jun 2017 00:42:00 -0400
Message-ID: <20170622044200.lf6klrvlxlr2zbxy@thunk.org>
References: <20170620091435.13560-1-tahsin@google.com>
 <B63F04AF-ED74-4A05-BA5A-160A97C61106@dilger.ca>
 <CAAeU0aNUvSBkicQgnc9V4dWicZKWutum9aUsFy7oTLasRinhfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeU0aNUvSBkicQgnc9V4dWicZKWutum9aUsFy7oTLasRinhfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 04:46:48PM -0700, Tahsin Erdogan wrote:
> Remount option handling is a bit strange. If an option is not
> specified, it is not automatically cleared in sbi->s_mount_opt. So,
> once nombcache option is set in the original mount, it is not possible
> to clear it. I don't know whether this option handling behavior in
> ext4 is deliberate but because of that, the mount -o remount,ro does
> not result in a mount failure. The check above is effectively only to
> protect against going from not having nombcache option to having
> nombcache option, because the opposite is not possible.

The option handling behavior is deliberate, yes.  This is why we have
the mount options "lazytime" and "nolazytime", "discard" and
"nodiscard", "barrier" and "nobarrier", etc.

							 -Ted
