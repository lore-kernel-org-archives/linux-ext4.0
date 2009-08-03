From: ranjith kannikara <ranjithkannikara@gmail.com>
Subject: Help to read journal content
Date: Mon, 3 Aug 2009 17:16:06 +0530
Message-ID: <20aa8c370908030446n59325e14j41e4cc72d86a9bae@mail.gmail.com>
References: <20aa8c370908030417he494294i890e804e6a552488@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:38601 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbZHCLqH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 07:46:07 -0400
In-Reply-To: <20aa8c370908030417he494294i890e804e6a552488@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We are doing a project to make an applicatio that can recover the
deleted data from an ext3 filesystem
<http://sourceforge.net/projects/recoverext3/>. We ahve used the tools
foremost and debugfs to debug the filesystem and read the journal.
Is there any way to read the journal?
Or How can we read the journal of a filesystem.
The inode number of the journal is present in the ext3_super_block
structure. But We are able to open the inode only with the help of
these tools.
Can someone guide us to where tio find the details of how a journal can be read.

Regards
Ranju.
