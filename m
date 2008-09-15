From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] jbd2: Create proc entry with
	bdevname+i_ino.
Date: Sun, 14 Sep 2008 18:19:36 -0700
Message-ID: <20080915011936.GB29193@mail.oracle.com>
References: <20080908233114.GD20100@mail.oracle.com> <20080914084003.GP4563@wotan.suse.de> <20080914090306.GF30537@mit.edu> <20080914163117.GA13074@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Fasheh <mfasheh@suse.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:12658 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYIOBVz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2008 21:21:55 -0400
Content-Disposition: inline
In-Reply-To: <20080914163117.GA13074@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 12:31:17PM -0400, Theodore Tso wrote:
> This is what plan to push instead.  It should address ocfs2's
> requirement.  In addition, it reduces jbd2 and ext4's stack usage,
> removes 30 lines of code, and fixes a potential problem with pesky
> block devices which contain '/' character in their names.  Four for
> the price of one!

	I like it!  I don't have time to test it (KS/LPC), but hopefully
Sunil can.

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
