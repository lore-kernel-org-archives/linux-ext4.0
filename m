From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 4/6] ubifs: Maintain a parent pointer
Date: Fri, 2 Dec 2016 11:36:37 +0100
Message-ID: <c8633ae8-9f17-8366-aae1-4bdbe4b8b141@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-5-git-send-email-richard@nod.at>
 <20161202092840.i67lhgglzlnugwpd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at, tytso@mit.edu,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161202092840.i67lhgglzlnugwpd@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02.12.2016 10:28, Marcus Folkesson wrote:
> On Thu, Dec 01, 2016 at 11:02:19PM +0100, Richard Weinberger wrote:
>>  
>> +	if (new_dir != old_dir) {
>> +		fst_inode_ui->parent_inum = new_dir->i_ino;
>> +		snd_inode_ui->parent_inum = old_dir->i_ino;
>> +	}
>> +
>>  	if (old_dir != new_dir) {
>>  		if (S_ISDIR(fst_inode->i_mode) && !S_ISDIR(snd_inode->i_mode)) {
>>  			inc_nlink(new_dir);
> 
> Insignificant thing, but use the existing if-statment instead?

Of course.
I moved the line around and oversaw the existing branch. :)

Thanks,
//richard
