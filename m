From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH 1/2] ext4: create function to read journal inode
Date: Thu, 22 Sep 2016 12:38:42 -0400
Message-ID: <20160922163842.GB14239@localhost.localdomain>
References: <20160922011450.GB27216@localhost.localdomain>
 <20160922150353.GA19971@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33311 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754280AbcIVQei (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Sep 2016 12:34:38 -0400
Received: by mail-qk0-f195.google.com with SMTP id n66so5533443qkf.0
        for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2016 09:34:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160922150353.GA19971@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Jan Kara <jack@suse.cz>:
> On Wed 21-09-16 21:14:50, Eric Whitney wrote:
> > Factor out the code used in ext4_get_journal() to read a valid journal
> > inode from storage, enabling its reuse in other functions.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> BTW: I didn't see PATCH 2/2?
> 

Yup, my mistake.  I reposted it earlier today - hopefully it's now visible.

Thanks for the review!

Eric
