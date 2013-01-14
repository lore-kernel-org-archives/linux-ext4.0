From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk
 fails
Date: Sun, 13 Jan 2013 23:18:28 -0500
Message-ID: <20130114041828.GD29329@thunk.org>
References: <0rm2m33qfluh6ajvvbqqeljp.1358136405625@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-ext4@vger.kernel.org
To: Wang <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43186 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab3ANESc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jan 2013 23:18:32 -0500
Content-Disposition: inline
In-Reply-To: <0rm2m33qfluh6ajvvbqqeljp.1358136405625@email.android.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 12:10:51PM +0800, Wang wrote:
> I am sorry, i am a newbie....
> I make it confused what it  means if
> i bcc stable@vger.kernel.org......

Yeah, don't do that.  (1) Bcc's are bad since they're not visible, so
others can't comment on whether it's appropriate for a patch to be
marked as going into stable, and (2) what's important is that the
commit is tagged as going into the stable in the commit description,
so when the commit hits Linus's git tree, the scripts run by the
stable kernel maintainers will automatically take those commits and
start processing them for backporting into the stable git trees.

You can tag a patch with Cc: stable@vger.kernel.org, i.e:

    Signed-off-by: Eryu Guan <guaneryu@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

Generally the maintainer (i.e., me for ext4, Jan Kara for ext3) will
take care of adding the stable@vger.kernel.org if we think it's
appropriate.  Feel free to add such an annotation as a suggestion to
us, but we may end up adding or removing such a tag, just as I often
will end up clarifying the commit description (either for English
grammar/readability, or to make it clearer for people deciding whether
they should backport the patch into distro kernels, etc.)

Cheers.

						- Ted
