From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 06:32:17 -0500
Message-ID: <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu>
References: <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:63677 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab1BWLhY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 06:37:24 -0500
In-Reply-To: <20110223044427.GM21917@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 22, 2011, at 11:44 PM, Rogier Wolff wrote:

> 
> I'll shoot off an Email to the TDB guys as well. 

I'm pretty sure this won't come as a surprise to them.   I'm using the last version of TDB which was licensed under the GPLv2, and they relicensed to GPLv3 quite a while ago.   I remember hearing they had added a new hash algorithm to TDB since the relicensing, but those newer versions aren't available to e2fsprogs....

-- Ted

