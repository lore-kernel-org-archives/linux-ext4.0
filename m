From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4 03/15] vfs,hot_track: add the function for collecting I/O frequency
Date: Mon, 29 Oct 2012 10:14:39 +0800
Message-ID: <CAEH94LhyW8THc1JNgaCeptiN9ErUHALrpsT0BK=bXa8gMq3iRQ@mail.gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
	<1351177747-19389-4-git-send-email-zwu.kernel@gmail.com>
	<20121028075520.GA14554@gmail.com>
	<CAEH94LidECTUHb0_Wujyg=zH18+dzxMPTUUpiYBeUSiG7MpSKQ@mail.gmail.com>
	<20121029020124.GP29378@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121029020124.GP29378@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 29, 2012 at 10:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Oct 28, 2012 at 09:51:48PM +0800, Zhi Yong Wu wrote:
>> On Sun, Oct 28, 2012 at 3:55 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
>> > Hi Zhiyong,
>> >
>> > On Thu, Oct 25, 2012 at 11:08:55PM +0800, zwu.kernel@gmail.com wrote:
>> > [snip]
>> >> @@ -199,6 +342,54 @@ err:
>> >>  }
>> >>
>> >>  /*
>> >> + * Main function to update access frequency from read/writepage(s) hooks
>> >> + */
>> >> +inline void hot_update_freqs(struct inode *inode, u64 start,
>> >> +                     u64 len, int rw)
>> >
>> > This function seems too big.  So we really need to inline this function?
>> As Dave said in his comments, it will add a function call
>> overhead even when tracking is not enabled. a static inline function
>> will just result in no extra overhead other than the if
>> statement....
>
> I don't think I said that with respect to this code. I think I said
> it w.r.t. a define or a small wrapper that decides to call
> hot_update_freqs().  A static inline fucntion should only be a
> couple of lines of code at most.
>
> A static function, OTOH, can be inlined by the compiler if the
> compiler thinks that is a win. But....
thanks for your explaination at first.
>
> .....
>
>> >> +EXPORT_SYMBOL_GPL(hot_update_freqs);
>
> ... it's an exported function, so it can't be inline or static, so
> using "inline" is wrong whatever way you look at it. ;)
ah, but i' m surprised by why the compiler find this error.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
