From: Tao Ma <tm@tao.ma>
Subject: [RFC] Add inline data support in ext4
Date: Tue, 27 Sep 2011 15:11:09 +0800
Message-ID: <4E81770D.8090309@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:38167 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751348Ab1I0HLU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Sep 2011 03:11:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and the list,
	As you may already know, we are beginning to evaluate the bigalloc
features in our production system. The performance looks promising, but
we have also met with a severe problem with bigalloc.

As ext4 now allocates one block for the directory even if it is empty,
it is really space-consuming for some applications which uses hashes and
create large numbers of directories(AUFS in squid for example).

ocfs2 now uses inline data for a new created file/dir so that some small
ones can have their data within the inodes. It is really helpful and we
are considering adding the same to ext4.

What is your option? I haven't been involved in ext4 for a long time, so
I am not sure whether there was a similar try which was abandoned
finally. Anyway, with bigalloc added, it is really needed for us to
support inline data now.

Thanks
Tao
