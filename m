From: Marcel Partap <mpartap@gmx.net>
Subject: recover file reset to 0 size?
Date: Sat, 15 Dec 2007 18:54:07 +0100
Message-ID: <476414BF.9090403@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47483 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752275AbXLORyK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Dec 2007 12:54:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear ext4 developers,
I have a small problem here on a partition mounted as ext4dev and thought there might be a slight
chance you can help me out. I recorded a movie from UDP DVB stream into a file with VLC.. then at
some point after I switched the channel and made VLC reconnect, but forgot it was in dump stream
mode. I instantly killed the darn thing and looked at the file but it was too late, 0 Bytes.
So from what I understand about this extents stuff, the first inode had its extents reset from 18Gig
to 0. If so, is there a way I could probably undo that? The file should be completly unfragmented as
there was more than 100Gig left and I had no other writes to that partition at that time.. It was a
rare movie and there is no scheduled repetition so I would be thankful if someone had an idea.
regards, marcel
