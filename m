From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 3/6] ubifs: Use 64bit readdir cookies
Date: Thu, 29 Dec 2016 11:59:20 -0500
Message-ID: <20161229165920.GA29744@fieldses.org>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-4-git-send-email-richard@nod.at>
 <20161229025835.GC21325@fieldses.org>
 <bf60916c-e0f2-387c-ce21-325ad8977539@nod.at>
 <20161229153407.GA29149@fieldses.org>
 <fe46ea3c-ef8f-40ba-f4ab-8dfe8faafb0b@nod.at>
 <20161229161534.GA29261@fieldses.org>
 <224abf2f-c820-5df1-6292-42c1e2d47933@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at, tytso@mit.edu,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <224abf2f-c820-5df1-6292-42c1e2d47933@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 29, 2016 at 05:36:35PM +0100, Richard Weinberger wrote:
> Bruce,
> 
> On 29.12.2016 17:15, J. Bruce Fields wrote:
> > On Thu, Dec 29, 2016 at 04:49:54PM +0100, Richard Weinberger wrote:
> >> Bruce,
> >>
> >> On 29.12.2016 16:34, J. Bruce Fields wrote:
> >>>> That way UBIFS can provide a 64bit readdir() cookie which is required for NFS3.
> >>>
> >>> Sounds good.  And if a matching entry isn't found (as in the case of a
> >>> concurrent unlink), what happens?  The answer must be the same as for
> >>> ext4, but I've forgotten the details....  I guess it must find the next
> >>> highest cookie (thinking of the cookie as a 64-bit integer of some kind)
> >>> that exists in the directory.  And that must be the same order that
> >>> readdir normally returns entries in.
> >>
> >> If a 64bit cookie is not found, the lookup function returns -ENOENT.
> >> In UBIFS we cannot just select a higher or lower key (cookie in this case),
> >> since it is the B-tree key and would point to a completely different
> >> entry.
> >>
> >> So, in case of a concurrent unlink() one would succeed and one fail with
> >> -ENOENT. Unless I miss something that seems okay to me.
> > 
> > Unlink takes (parent directory, name), not a directory cookie.
> > 
> > The problem is concurrent unlink and nfs readdir.  So:
> > 
> > 	NFS server returns readdir result with cookie X
> > 
> > 	Somebody unlinks the entry at X.
> > 
> > 	NFS server gets readdir request with cookie X.
> > 
> > Then the NFS client will get a spurious -ENOENT.
> 
> Ah yes. Sorry I misunderstood your question.
> UBIFS readdir() address this already, if you ask it to readdir()
> from pos X and X is not present it will jump to the next best entry X'.
> UBIFS does so since ever.

OK, good.  So the random nonce is stored with the entry, and the hash
you can always recalculate from the filename, so if you return entries
in nonce+hash order, then you can keep that order stable even across
deletes and renames.

--b.
