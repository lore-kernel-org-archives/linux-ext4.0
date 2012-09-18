From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Mon, 17 Sep 2012 23:59:31 -0400
Message-ID: <20120918035931.GB32195@thunk.org>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
 <20120915183023.GA9895@thunk.org>
 <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
 <20120917153701.GA5510@thunk.org>
 <20120917182604.GA1959@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51220 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab2IRD7e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 23:59:34 -0400
Content-Disposition: inline
In-Reply-To: <20120917182604.GA1959@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 17, 2012 at 03:26:04PM -0300, Carlos Maiolino wrote:
> 
> based on this conversation, is there anything else I should do to have this
> patch accepted?

OK, I've applied this patch to my tree.  However, I would really
appreciate if you could indeed review the callers for ext4_bread() and
ext3_bread() and send patches for ext3 and ext4 as you have suggested,
thanks!!

						- Ted
