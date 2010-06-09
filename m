From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: e4defrag and immutable files
Date: Tue, 8 Jun 2010 18:10:28 -0700
Message-ID: <20100609011028.GD6795@mail.oracle.com>
References: <4C002427.3010706@zytor.com>
 <4C05604D.2070401@oracle.com>
 <20100601194924.GF4426@thunk.org>
 <4C06083B.7050102@zytor.com>
 <4C069CAA.50304@oracle.com>
 <4C0EC034.6010603@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:43130 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FIBLs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jun 2010 21:11:48 -0400
Content-Disposition: inline
In-Reply-To: <4C0EC034.6010603@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 08, 2010 at 03:12:04PM -0700, H. Peter Anvin wrote:
> On 06/02/2010 11:02 AM, Sunil Mushran wrote:
> > "Immutable" means the contents do not change. But the file mappings
> > could change.
> > 
> > "Fixed mapping" means the mappings do not change but contents
> > could (as long as the ondisk mappings don't).
> > 
> > "Fixed metadata" means the entire inode (mappings included) cannot
> > change but the contents could (as long as the ondisk mappings don't).
> > (This does have the side effect of allowing writes without touching the
> > mtime. Like XFS' invisible i/o.)
> > 
> 
> Actually, if you're going to have three flags you might as well make
> them orthogonal.  That is, separate "fixed contents", "fixed mappings",
> "fixed metadata" -- and don't consider the mapping as metadata for this
> purpose.

	I think Sunil was defining terms, not suggesting three flags ;-)
That said, it does allow all the possible characteristics in the
discussion.  The only ugly think I can see is that we'll have three new
flags, plus the old immutable flag that means the same as setting all
three new flags.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
