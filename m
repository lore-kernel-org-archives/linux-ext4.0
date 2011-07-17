From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 2/3] ext4 directory index: read-ahead blocks v2
Date: Sun, 17 Jul 2011 09:12:47 -0400
Message-ID: <31F2FDF7-1CED-4831-87E1-861752A6899A@mit.edu>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain> <20110620202854.2473133.32514.stgit@localhost.localdomain> <20110716235950.GC2717@thunk.org> <4E22348E.5060707@fastmail.fm>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-ext4@vger.kernel.org, adilger@whamcloud.com, colyli@gmail.com
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:46124 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab1GQNMw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 09:12:52 -0400
In-Reply-To: <4E22348E.5060707@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 16, 2011, at 9:02 PM, Bernd Schubert wrote:

> I don't understand it either yet why we have so many, but each directory
> has about 20 to 30 index blocks

Hmm.....  can you send me the output of ls -ld on one or two of the directories?  I want to see how big they are.

Also, just as a sanity check can you send me the following:

debugfs -R "htree /path/to/a/typical/directory" /dev/sdXX | gzip -9 > /tmp/htree_dump.gz2

I just want to take a look at the structure of one of these htrees and see if there's anything surprising going on....


-- Ted

