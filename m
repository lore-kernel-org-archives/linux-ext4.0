From: Arthur Jones <ajones@riverbed.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 13:48:40 -0800
Message-ID: <20081103214840.GA3371@ajones-laptop.nbttech.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756853AbYKCVsy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081103123750.67c96224.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Andrew, ...

On Mon, Nov 03, 2008 at 12:37:50PM -0800, Andrew Morton wrote:
> [...]
> OK.  But still, questions remain.
> 
> - should we clear s_dirt if log_wait_commit() didn't work?
> 
> - ext3_force_commit() clears s_dirt also

I'm not sure if it makes sense, but ATM I don't think it
hurts anything given that ext3_write_super is just sb->s_dirt = 0;

> - should ext3_sync_fs() be dropping the ext3_force_commit() return
>   value on the floor?

Something like this (tested)?

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2b48b85..743acf1 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2386,13 +2386,15 @@ static void ext3_write_super (struct super_block * sb)
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
+	int ret = 0;
+
 	sb->s_dirt = 0;
 	if (wait)
-		ext3_force_commit(sb);
+		ret = ext3_force_commit(sb);
 	else
 		journal_start_commit(EXT3_SB(sb)->s_journal, NULL);
 
-	return 0;
+	return ret;
 }
 
 /*

Arthur
