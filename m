From: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: Help to edit inode content
Date: Tue, 12 May 2009 11:56:03 -0400
Message-ID: <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: ranjith kannikara <ranjithkannikara@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758945AbZELP4Y@vger.kernel.org>
In-Reply-To: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
<ranjithkannikara@gmail.com> wrote:
> Hi,
> I am a computer science engineering student. We have started a project
> to make an application to recover deleted files from an ext3
> filesystem. For that we have a doubt . Can we edit the inode content?
> ie the recovery will be robust if we could edit the inode contents and
> give the pointer address manually or through a code. The inode is
> being created in the kernel mode and is it possible to edit those
> contents if the code is allowed to have the kernel mode permissions..?

You'd probably be best off doing this in userspace, with the
filesystem unmounted.
Generally speaking, don't attempt to alter the filesystem from
userspace while it is mounted.
