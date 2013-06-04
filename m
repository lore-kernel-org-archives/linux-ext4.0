From: Ruslan Bilovol <ruslan.bilovol@ti.com>
Subject: Re: [PATCH 1/2] jbd2: check bh->b_data for NULL in
 jbd2_journal_get_descriptor_buffer before memset()
Date: Tue, 4 Jun 2013 14:15:57 +0300
Message-ID: <CAB=otbT15wLGkb_A9pa7-U=wH-_gOPgOR9Ee4uSL7_P0BmXt4Q@mail.gmail.com>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
	<1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
	<20130603153323.GB20009@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ruslan Bilovol <ruslan.bilovol@ti.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130603153323.GB20009@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Mon, Jun 3, 2013 at 6:33 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 03, 2013 at 01:00:15PM +0300, Ruslan Bilovol wrote:
>> The memset() doesn't perform any NULL-pointer checking
>> before dereferencing passed pointer so this should be
>> checked before calling it.
>
> I can see that __getblk() can return NULL if there is a memory
> allocation failure (and is defined to do so), so checking to make sure
> bh is not NULL is a good thing to do.
>
> Have you actually seen a case where bh is non-NULL, but bh->b_data is
> NULL?  If not, it might be better to do something like this:

Yes, this is exactly the situation I observe (bh is non-NULL, but
bh->b_data is NULL)

>
>>       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
>         if (!bh)
>                 return NULL;
>         BUG_ON(!bh->b_data);

Is it so critical that we need to stop the kernel here?
Can we recover from this state gracefully?
Maybe something like this may be better:

       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
         if (!bh)
                 return NULL;
         if(!bh->b_data) {
                 WARN_ON(1);
                 return NULL;
         }

Regards,
Ruslan

>
>                                                 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards,
Ruslan Bilvol
