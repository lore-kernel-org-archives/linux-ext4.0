From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
	for fallocate
Date: Wed, 19 Feb 2014 10:08:39 +0900
Message-ID: <CAKYAXd9E41d2Kt+Sz-d3toUFUrTLtjrOYqq32NQViM_abRWTxg@mail.gmail.com>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
	<CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
	<alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<CAKYAXd_xpWg-=T_1PghL_u9wDKTX_Ey5mJxbgVVKth8NoexQQg@mail.gmail.com>
	<20140218143005.GO26580@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <linkinjeon@gmail.com>, jack@suse.cz,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com,
	adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org,
	=?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, mtk.manpages@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140218143005.GO26580@thunk.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

2014-02-18 23:30 GMT+09:00, Theodore Ts'o <tytso@mit.edu>:
> Namjae,
Hi Ted.
>
> Did you respond to Matthew Wilcox's comments/question from Feb. 2nd?
Sorry, I didn't catch about this.
I just replied from Matthew's mail.
Thanks for your remind.
>
>> > What if the file is mmaped at the time somebody issues this command?
>> > Seems to me we should drop pagecache pages that overlap with the
>> > removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
>> > then we should also drop any pagecache pages after the removed range.
>>
>> Oops, forgot to add "and if it is a multiple of page size, then we need
>> to update the offsets of any pages after the removed page".
>
> Dave responded that XFS does the right thing when doing a punch hole
> operation, but it wasn't obvious to me whether FL_COLLAPSE_RANGE does
> the right thing with ext4.
>
> Thanks,
>
> 					- Ted
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
