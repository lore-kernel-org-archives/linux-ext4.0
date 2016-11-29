From: Richard Weinberger <richard@nod.at>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Tue, 29 Nov 2016 22:59:28 +0100
Message-ID: <87d9b3aa-684d-856a-0dcd-f960923f2484@nod.at>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
 <CA+POJK10M3_GhP_Ge4qkQF4gSNMUXVr5kem9Ak4EDmVRvRUg7g@mail.gmail.com>
 <f9bc005b-4e25-d705-e091-5f930e4246b1@nod.at>
 <CAKpBdu1+k94WmwxeZ2Hyu5=ifNprPA0YedRm2xps-ooyVHTwhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Michael Halcrow <mhalcrow@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, kzak@redhat.com,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Joe Richey <joerichey@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKpBdu1+k94WmwxeZ2Hyu5=ifNprPA0YedRm2xps-ooyVHTwhg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Joe,

On 29.11.2016 22:42, Joe Richey wrote:
> Hi Richard,
> 
> I'm Joe Richey, and I work on Mike's team. We've been playing around
> with a few design
> ideas regarding a tool for managing filesystem encryption. After going
> though some iterations
> with Ted, we have a fairly good idea about where to head design wise,
> and I'm working on a
> design document for it. It's a bit preliminary at this point, but I
> can share it if you want.
> 
> Our goal is to have a finished doc by end of Q4 and then get your and
> Jaegeuk's feedback.

Thanks for your quick response!
I hoped you had already some code, but having a decent design document
is also nice. I'm eager to read it.

Do you also plan to address d/page cache related issues?
i.e. when two users are logged into the system user rw
is able to see decrypted file names and contents in /home/dags/
if user dags installs a key and accessed a file.

Or files in /home/dags/ are still readable even after
user dags purged the key.

The tool could play games with CLONE_NEWNS to hide directories.
To provide a correct "logout" we could expose shrink_dcache_parent()
to usespace such that the emerging tool can purge the key and flush
the dcache on the encrypted directory. But I fear exposing shrink_dcache_parent()
is not a good idea. :-)

Just some random ideas...

Thanks,
//richard
