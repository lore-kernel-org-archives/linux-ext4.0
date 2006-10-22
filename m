From: "=?gb2312?B?ufnD99H0?=" <guomingyang@nrchpc.ac.cn>
Subject: a question about ext4_fsblk_t
Date: Sun, 22 Oct 2006 15:38:00 +0800
Message-ID: <200610220746.k9M7kRHv012761@nrchpc.ac.cn>
Reply-To: guomingyang@nrchpc.ac.cn
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: "linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello everyone:

		I am a student interesting in linux filesystem, I have a problem about the replace of block number type to ext4_fsblk_t. Is it complete? Or has it passed all the test? Because I have found a place like this in linux-2.6.19-rc2/fs/ext4/inode.c 



+struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
+                               int block, int create, int *err)


the block's type is not changed. Although I think it will bring no mistake, I doubt about why not change it. Thank you !


guomingyang

