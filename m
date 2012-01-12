From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Fix filesystem freezing
Date: Thu, 12 Jan 2012 02:20:49 +0100
Message-ID: <1326331253-6497-1-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


  Hello,

  filesystem freezing is currently racy and thus we can end up with dirty data
on frozen filesystem (see changelog of the first patch for detailed race
description and proposed fix). This patch series aims at fixing this. So far I
did basic testing using UML linux (running fsstress and bash-shared-mapping
while doing freeze - sync (to deadlock on leftover dirty pages) - unfreeze) and
I'm not able to trigger dirty pages on frozen filesystem anymore. I plan to do
more testing on real machine tomorrow. Surbhi, Kamal, you were able to
reproduce deadlocks due to dirty data as well so please test these patches out.
Thanks. Also review of patches is welcome.

								Honza
