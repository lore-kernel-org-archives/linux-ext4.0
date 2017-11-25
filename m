From: Andi Kleen <andi@firstfloor.org>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Fri, 24 Nov 2017 17:42:38 -0800
Message-ID: <20171125014238.GT2482@two.firstfloor.org>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Ts'o <tytso@mit.edu>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:59856 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdKYBml (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Nov 2017 20:42:41 -0500
Content-Disposition: inline
In-Reply-To: <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Sure, but not many people are going to be running a 4.14 kernel with
> a 2007 system.  

It's not just root, but any disk. People could well have 10 year old
disks.

> Could you please run the updated find command to see
> whether this is an isolated case, or if it is a common case:
> 
> find / -type l -size -60c -print0 | xargs -0r ls -dils | awk '$2 != 0 { print }'

Pretty much all symlinks on / hit it. / has 1278 symlinks total, and 
1218 match the line above.

-Andi
