From: Camille Moncelier <pix@devlife.org>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been
	remounted readonly
Date: Wed, 24 Feb 2010 17:26:37 +0100
Message-ID: <baaef4711002240826t1b447662yf66c980dea1d9d00@mail.gmail.com>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com> <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
	<20100222223252.GA13882@atrey.karlin.mff.cuni.cz> <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
	<16F918FB-F45D-478E-9358-550BB39E277E@sun.com> <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
	<20100223135531.GA7699@atrey.karlin.mff.cuni.cz> <877hq2tyg8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <877hq2tyg8.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Theoretically some pages may exist after rw=>ro remount
> because of generic race between write/sync, And they will be written
> in by writepage if page already has buffers. This not happen in ext4
> because. Each time it try to perform writepages it try to start_journal
> and this result in EROFS.
> The race bug will be closed some day but new one may appear again.
>
> Let's be honest and change ext3 writepage like follows:
> - check ROFS flag inside write page
> - dump writepage's errors.
>
>
I think I don't understand correctly your patch. For me it seems that
when an ext3 filesystem is remounted ro, some data may not have been
written to disk right ?

But as far as I understand some writes are performed on the journal on
remount-ro, before the ro flag is set. So if writepage comes to play
and write data to disk it my have to update the journal again, no ? If
not it would mean that the journal would reference data that aren't
available on disk ?

Last question, would it be hard to implement a patch that trigger
writepage and wait for completion when remounting read-only (I have no
expertise on filesystems in general, but I tried my best to understand
the ext3 driver)

-- 
Camille Moncelier
http://devlife.org/

If Java had true garbage collection, most programs would
delete themselves upon execution.
