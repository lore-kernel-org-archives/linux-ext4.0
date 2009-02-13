From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: issue of ext3_file_write function & remote shares
Date: Fri, 13 Feb 2009 09:59:39 -0600
Message-ID: <499598EB.5010301@redhat.com>
References: <1234529184.3927.3.camel@Q0405CPU53.qualexsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kavita_Kulkarni@qualexsystems.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbZBMP7t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 10:59:49 -0500
In-Reply-To: <1234529184.3927.3.camel@Q0405CPU53.qualexsystems.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kavita Kulkarni wrote:
> The "ext3_file_write" function in the file
> "/usr/src/linux-source/fs/ext3/file.c" is called whenever a file is
> accessed/modified.
> Now, i have inserted a simple printk and some more code of mine in it
> immediately after declaration/initialization of variables. When a local
> file is accessed, this printk as well the other code is executed
> successfully. But when i export a share and mount it remotely and do
> some operations like writing to a file in it, neither my code nor even
> the simple printk(which is without any conditions) is executed.
> And after this takes place, it doesnt even work locally.
> I'm unable to find any solution.
> Any help will be welcome.

Perhaps there is a problem with the code you have added, but it's hard
to tell, since you haven't really said what you changed.  :)

-Eric
