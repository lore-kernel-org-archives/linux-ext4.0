From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/37] libext2fs: create sockets when populating
 filesystem
Date: Sun, 11 May 2014 18:44:11 -0400
Message-ID: <20140511224411.GE5480@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231242.31890.24539.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021321250.2154@localhost.localdomain>
 <20140505200839.GG8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33451 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaEKWoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 18:44:14 -0400
Content-Disposition: inline
In-Reply-To: <20140505200839.GG8434@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.  I've fixed up the issues which Luk=C3=A1=C5=A1 pointe=
d out,
including replacing the -1 return with EROFS.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
