From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] ext4: Convert int to vm_fault_t type
Date: Wed, 1 Aug 2018 18:56:39 +0530
Message-ID: <CAFqt6zYJv7SdkntY7KOBvNyfk-9MRaXBMmkbsc4J7P-tq616DA@mail.gmail.com>
References: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
 <20180801125512.GA10761@thunk.org> <CAFqt6zbxpj5DS=ONUGTJ9zaeH5k=qZpQYy-J+08tr9y0gOsCAg@mail.gmail.com>
 <20180801131330.GA4734@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        Sabyasachi Gupta <sabyasachi.linux@gmail.com>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801131330.GA4734@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 1, 2018 at 6:43 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Wed, Aug 01, 2018 at 06:34:45PM +0530, Souptick Joarder wrote:
>> > The fact that ext4_page_mkwrite() returns a vm_fault_t, while
>> > block_page_mkwrite() returns an int which then has to get translated
>> > into a vm_fault_t via block_page_mkwrite_return() is I suspect going
>> > to confuse an awful lot of callers.
>>
>> We have also changed block_page_mkwrite() to return vm_fault_t, but in
>> a different patch. Hopefully that patch will be in linux-next tree soon.
>
> I didn't sign off on that, so that's not "we", but "I".  And this is
> completely against everything I've been telling you for this whole effort.
> Patches should each make sense individually.  You can't make this patch
> dependent on another patch without putting that in writing.

It was mistake form my side. Sorry about it.

>
> Leave block_page_mkwrite() alone for now.  Eventually it should return
> a vm_fault_t, probably.  But that patch needs to be delayed at least
> one kernel cycle.

As caller of block_page_mkwrite() are -
fs/ext4/inode.c
fs/nilfs2/file.c

I will merge both changes in a single patch and send it.
