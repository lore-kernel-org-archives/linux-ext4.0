From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 19:56:58 +0530
Message-ID: <CAKLKtzdLvRNFWiAV_ssFfSQFTMmgq+jHq4LNG9H70Zq9WZm5yg@mail.gmail.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
	<20120611122736.GA14051@thunk.org>
	<CAKLKtzeo1x+0Kxd0+29yqvXh4FBiS+p=T7b1-BWb6HXH5e1hhQ@mail.gmail.com>
	<201206121329.25953.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <201206121329.25953.arnd.bergmann@linaro.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12 June 2012 18:59, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> On Tuesday 12 June 2012, Saugata Das wrote:
>> On 11 June 2012 17:57, Ted Ts'o <tytso@mit.edu> wrote:
>> > On Mon, Jun 11, 2012 at 02:41:31PM +0300, Artem Bityutskiy wrote:
>> > The proof-of-concept patches seem to use the inode number as a way=
 of
>> > trying to group related writes, but what about at a larger level t=
han
>> > that? =A0For example, if we install a RPM or deb package where all=
 of
>> > the files will likely be replaced together, should that be given t=
he
>> > same context?
>>
>> In this patch, context is used at file level based on inode number.
>> So, in the above example, multiple contexts will be used for the
>> directory, file updates during RPM installation.
>>
>> >
>> > How likely does it have to be that related blocks written under th=
e
>> > same context must be deleted at the same time for this concept to =
be
>> > helpful?
>>
>> There is no restriction that related blocks within the MMC context
>> needs to be deleted together
>
> I don't think that is correct. The most obvious implementation in eMM=
C
> hardware for this would be to group all data from one context to be
> written into the same erase block, in order to reduce the amount
> of garbage collection that needs to happen at erase time. AFAICT,
> the main interest here is, as Ted is guessing correctly, to make sure
> that all data which gets written into one context has roughly the
> same life time before it gets erased or overwritten.
>

The restriction is there on "large unit" context, which prevents
trim/erase of the blocks till the context is active. But we do not
enable "large unit". On non-"large unit" context, the specification
does not restrict the trim/erase of blocks based on context.


>> > If we have a context where it is the context assumption does
>> > not hold (example: a database where you have a random access
>> > read/write pattern with blocks updated in place) how harm will it =
be
>> > to the device format if those blocks are written under the same
>> > context?
>> >
>>
>> MMC context allows the data blocks to be overwritten or randomly acc=
essed
>
> That is of course the defined behavior of a block device that does
> not change with the use of contexts. To get the best performance,
> a random-write database file would always reside in a context by itse=
lf
> and not get mixed with long-lived write-once data. If we have a way
> in the file system to tell whether a file is written linearly or rand=
omly
> (e.g. by looking at the O_APPEND or O_CREAT flag), it might make sens=
e
> to split the context space accordingly.
>
>> > The next set of questions we need to ask is how generalizable is t=
his
>> > concept to devices that might be more sophisticated than simple eM=
MC
>> > devices. =A0If we're going to expose something all the way out to =
the
>> > file system layer, it would be nice if it worked on more than just
>> > low-end flash devices, but also on more sophisticated devices as w=
ell.
>> >
>>
>> This context mechanism will be used on both UFS and MMC devices. If
>> there are some alternate suggestions on what can be used as context
>> from file system perspective, then please =A0suggest.
>
> One suggestion that has been made before was to base the context on
> the process ID rather than the inode number, but that has many other
> problems, e.g. when the same file gets written by multiple processes.
>
> =A0 =A0 =A0 =A0Arnd
