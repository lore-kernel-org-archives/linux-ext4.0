From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] test-appliance: add new test configuration:
 ext4/lustre_mds
Date: Fri, 9 Jun 2017 13:59:11 -0400
Message-ID: <20170609175910.shwqocbi3npfmoid@thunk.org>
References: <20170609035943.26447-1-tytso@mit.edu>
 <CAO3qy=EVQtVVe2hvEvaYOTyArPpK7U6AYA9abu6Zum-p_sWqpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37664 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbdFIR7Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Jun 2017 13:59:16 -0400
Content-Disposition: inline
In-Reply-To: <CAO3qy=EVQtVVe2hvEvaYOTyArPpK7U6AYA9abu6Zum-p_sWqpg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 09, 2017 at 11:55:56AM +0300, Artem Blagodarenko wrote:
> Hello Theodore,
> 
> Is it good time to add large_dir feature to this configuration?

Andreas didn't include large_dir on the list of features that he
enabled; what's the status of use of that feature by Luster system in
production?

					- Ted
