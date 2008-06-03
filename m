From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Tue, 03 Jun 2008 14:11:44 +0900
Message-ID: <4844D290.7000802@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com>
    <20080602124409.GL30613@duck.suse.cz> <4844CB39.6060409@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	tytso@mit.edu, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48784 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYFCFLt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 01:11:49 -0400
In-Reply-To: <4844CB39.6060409@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hidehiro Kawai wrote:

> Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io

Sorry, I forgot to remove the subject at the first line...

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

