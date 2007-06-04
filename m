From: Kirk True <kirk@mustardgrain.com>
Subject: Failures in e2fsprogs-1.39-tyt3 'make check'
Date: Mon, 4 Jun 2007 01:18:23 -0700 (PDT)
Message-ID: <46497.24764.qm@web606.biz.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web606.biz.mail.mud.yahoo.com ([209.191.88.219]:23530 "HELO
	web606.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752075AbXFDISX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2007 04:18:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I'm getting some errors in the 'make check' step when building 
e2fsprogs-1.39-tyt3. Many of the errors look to be as a result of
missing image files, for example:

    f_orphan_dotdot_ft: filetype of .. in orphaned directories: 
    ../../tests/run_e2fsck: line 43: 
    ../../tests/f_orphan_dotdot_ft/image.gz: No such file or directory
    rm: cannot remove `./test.img': No such file or directory

Sorry if this is a documented, known issue. I'm just being paranoid and
don't want to do a 'make install' if it will hose up the box.

Thanks,
Kirk
