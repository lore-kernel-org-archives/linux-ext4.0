From: "guomingyang" <guomingyang@nrchpc.ac.cn>
Subject: Re: a question about ext4_fsblk_t
Date: Sun, 22 Oct 2006 16:50:04 +0800
Message-ID: <200610220858.k9M8wWHv013173@nrchpc.ac.cn>
Reply-To: guomingyang@nrchpc.ac.cn
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: "guomingyang@nrchpc.ac.cn" <guomingyang@nrchpc.ac.cn>,
	"linux-ext4" <linux-ext4@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



   I also find many places where the block number type is not changed in namei.c and dir.c. Why? 
   Thank you to anyone who offer help
>Hello everyone:
>
>		I am a student interesting in linux filesystem, I have a problem about the replace of block number type to ext4_fsblk_t. Is it complete? Or has it passed all the test? Because I have found a place like this in linux-2.6.19-rc2/fs/ext4/inode.c 
>
>
>
>+struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
>+                               int block, int create, int *err)
>
>
>the block's type is not changed. Although I think it will bring no mistake, I doubt about why not change it. Thank you !
>
>
>guomingyang
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

guomingyang

