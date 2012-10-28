From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4 03/15] vfs,hot_track: add the function for collecting I/O frequency
Date: Sun, 28 Oct 2012 21:51:48 +0800
Message-ID: <CAEH94LidECTUHb0_Wujyg=zH18+dzxMPTUUpiYBeUSiG7MpSKQ@mail.gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
	<1351177747-19389-4-git-send-email-zwu.kernel@gmail.com>
	<20121028075520.GA14554@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121028075520.GA14554@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 28, 2012 at 3:55 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi Zhiyong,
>
> On Thu, Oct 25, 2012 at 11:08:55PM +0800, zwu.kernel@gmail.com wrote:
> [snip]
>> @@ -199,6 +342,54 @@ err:
>>  }
>>
>>  /*
>> + * Main function to update access frequency from read/writepage(s) hooks
>> + */
>> +inline void hot_update_freqs(struct inode *inode, u64 start,
>> +                     u64 len, int rw)
>
> This function seems too big.  So we really need to inline this function?
As Dave said in his comments, it will add a function call
overhead even when tracking is not enabled. a static inline function
will just result in no extra overhead other than the if
statement....

>
> Regards,
> Zheng
>
>> +{
>> +     struct hot_info *root = inode->i_sb->s_hot_root;
>> +     struct hot_inode_item *he;
>> +     struct hot_range_item *hr;
>> +     u32 cur, end;
>> +
>> +     if (!root || (len == 0))
>> +             return;
>> +
>> +     he = hot_inode_item_find(root, inode->i_ino);
>> +     if (IS_ERR(he)) {
>> +             WARN_ON(1);
>> +             return;
>> +     }
>> +
>> +     spin_lock(&he->hot_inode.lock);
>> +     hot_freq_data_update(&he->hot_inode.hot_freq_data, rw);
>> +     spin_unlock(&he->hot_inode.lock);
>> +
>> +     /*
>> +      * Align ranges on RANGE_SIZE boundary
>> +      * to prevent proliferation of range structs
>> +      */
>> +     end = (start + len + RANGE_SIZE - 1) >> RANGE_BITS;
>> +     for (cur = (start >> RANGE_BITS); cur < end; cur++) {
>> +             hr = hot_range_item_find(he, cur);
>> +             if (IS_ERR(hr)) {
>> +                     WARN_ON(1);
>> +                     hot_inode_item_put(he);
>> +                     return;
>> +             }
>> +
>> +             spin_lock(&hr->hot_range.lock);
>> +             hot_freq_data_update(&hr->hot_range.hot_freq_data, rw);
>> +             spin_unlock(&hr->hot_range.lock);
>> +
>> +             hot_range_item_put(hr);
>> +     }
>> +
>> +     hot_inode_item_put(he);
>> +}
>> +EXPORT_SYMBOL_GPL(hot_update_freqs);



-- 
Regards,

Zhi Yong Wu
