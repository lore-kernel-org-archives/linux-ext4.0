From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Sun, 27 Mar 2016 21:31:58 +0200
Message-ID: <CA+icZUWgxMNjchWAxzsBxMsjbpsoZMng6U4t7heUGkiyxkH=jw@mail.gmail.com>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
	<CA+icZUWO82Mew_3BNS32EVU1zSzpoNQqTGNyJiEJsKUocEvUUg@mail.gmail.com>
	<20160327181506.GF31129@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160327181506.GF31129@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 27, 2016 at 8:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Mar 27, 2016 at 10:06:14AM +0200, Sedat Dilek wrote:
>> On Sat, Mar 26, 2016 at 10:09 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> > I have the following patches in the ext4.git tree which I plan to push
>> > to Linus as bug fixes during this development cycles.  Al, are you
>> > happy with Miklos's v2 version of "fs: add file_dentrY()" patch?
>> >
>> > Miklos Szeredi (4):
>> >   fs: add file_dentry()
>> >   nfs: use file_dentry()
>> >   ext4: use dget_parent() in ext4_file_open()
>> >   ext4: use file_dentry()
>> >
>> > Theodore Ts'o (1):
>> >   ext4 crypto: use dget_parent() in ext4_d_revalidate()
>> >
>>
>> I asked that already in a previous series of that patchset.
>>
>> Are those CC-stable-tags correct?
>>
>> fs: add file_dentry()
>> Cc: <stable@vger.kernel.org> # v4.2
>
> To quote from the commit description
>
>     This series fixes bugs in nfs and ext4 due to 4bacc9c9234c ("overlayfs:
>     Make f_path always point to the overlay and f_inode to the underlay").
>
> % git tag --contains 4bacc9c9234c | grep ^v | head -1
> v4.2
>

v4.2, OK.

fs: add file_dentry()
Cc: <stable@vger.kernel.org> # v4.2

nfs: use file_dentry()
Cc: <stable@vger.kernel.org> # v4.2

v4.5 ?

ext4: use file_dentry()
Cc: <stable@vger.kernel.org> # v4.5

- Sedat -
