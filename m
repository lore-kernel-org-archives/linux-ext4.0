From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 1/3] ext4: super: Fix spectre gadget in ext4_quota_on
Date: Tue, 31 Jul 2018 12:31:36 -0500
Message-ID: <20180731173136.rnhzvvvt3wtt2xdg@treble>
References: <20180727162357.30801-1-jcline@redhat.com>
 <20180727162357.30801-2-jcline@redhat.com>
 <20180727174654.bnooz26puuo7456w@treble>
 <E3E7B6AF-3819-4998-9B12-DACB4EBC14F1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jeremy Cline <jcline@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E3E7B6AF-3819-4998-9B12-DACB4EBC14F1@dilger.ca>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 31, 2018 at 12:39:41AM -0600, Andreas Dilger wrote:
> > Also it looks like XQM_MAXQUOTAS, MAXQUOTAS, and EXT4_MAXQUOTAS all
> > have the same value (3).  Maybe they can be consolidated to just use
> > MAXQUOTAS everywhere?
> 
> No, the filesystem-specific MAXQUOTAS values were separated from
> the kernel MAXQUOTAS value for a good reason.  This allows some
> filesystems to support new quota types (e.g. project quotas) that
> not all other filesystems can handle.  This may potentially change
> again in the future, so they shouldn't be tightly coupled.

But isn't that what sb->s_quota_types is for?  To allow different
filesystems to support different quota types?

Also I don't see any bounds checks for EXT4_MAXQUOTAS.  It seems like
the ext4 code assumes that MAXQUOTAS and EXT4_MAXQUOTAS are the same.

-- 
Josh
