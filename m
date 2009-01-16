From: Jan Kara <jack@suse.cz>
Subject: Quota fixes and improvements
Date: Fri, 16 Jan 2009 19:08:08 +0100
Message-ID: <1232129299-22018-1-git-send-email-jack@suse.cz>
References: <yes>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yes>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'm sending for review patches fixing some bugs and implementing new quota
features. First four patches fix possible deadlocks in OCFS2 quotas. I plan
to send them to Linus next week if nobody objects. The remaining patches
are going to linux-next and I plan to merge them in the next merge window.

								Honza
