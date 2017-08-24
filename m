From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: Delete an error message for a failed memory allocation in
 ext4_multi_mount_protect()
Date: Thu, 24 Aug 2017 13:44:45 -0400
Message-ID: <20170824174445.gfrkr35m4vcfuoat@thunk.org>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
 <5bf432ae-398d-718c-8105-3092a240a8ef@users.sourceforge.net>
 <b21f6c3d-2cad-3f72-f410-f608ea5f4cea@redhat.com>
 <e522d9a5-4d5a-b4a1-fe94-bb3aae4c5976@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e522d9a5-4d5a-b4a1-fe94-bb3aae4c5976@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 19, 2017 at 08:00:31PM +0200, SF Markus Elfring wrote:
> >> Omit an extra message for a memory allocation failure in this function.
> > 
> > I might be dense, but what makes this message "extra?"
> > 
> > (I suppose kmalloc squawks too if it fails,
> 
> Do you find the default allocation failure report sufficient?

>From a helpdesk reporting situation, having a more specific message
when there is a MMP failure causing the mount to fail is definitely
useful.

So, NACK.

					- Ted
