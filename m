From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck performance.
Date: Tue, 22 Feb 2011 17:13:04 -0500
Message-ID: <20110222221304.GH2924@thunk.org>
References: <20110220222013.GA2849@thunk.org>
 <20110220231514.GC21917@bitwizard.nl>
 <20110220234131.GC4001@thunk.org>
 <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com>
 <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com>
 <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca>
 <20110222102056.GH21917@bitwizard.nl>
 <20110222133652.GI21917@bitwizard.nl>
 <20110222135431.GK21917@bitwizard.nl>
 <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Pawe?? Brodacki <pawel.brodacki@googlemail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36579 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1BVWNK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 17:13:10 -0500
Content-Disposition: inline
In-Reply-To: <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 09:32:28AM -0700, Andreas Dilger wrote:
> 
> Any idea what the hash size does to memory usage?  I wonder if we
> can scale this based on the directory count, or if the memory usage
> is minimal (only needed in case of tdb) then just make it the
> default. It definitely appears to have been a major performance
> boost.

Yeah, that was my question.  Your patch adds a magic number which
probably works well on your machine (and I'm not really worried if
someone has less than 1G --- here's a quarter kid, buy your self a
real computer :-).  But I wonder if we should be using a hash size
which is sized automatically depending on available memory or file
system size.

					- Ted
