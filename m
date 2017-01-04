From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Wed, 4 Jan 2017 10:09:48 -0800
Message-ID: <CA+55aFzg5qR6DJvzrp+sreakzhPvT=txS-mo4OTrrwT0HVrKvw@mail.gmail.com>
References: <20170104161808.5ad7b4fd@kryten>
 <6085340.JSrffQ0Szo@localhost.localdomain>
 <20170104152837.wdh7cdncs7gyged7@thunk.org>
 <dc15451c-3c5e-1f61-f108-cea3c08332a9@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
 Jan Kara <jack@suse.cz>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Chandan Rajendra <chandan@linux.vnet.ibm.com>,
 Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 ppc-dev <linuxppc-dev@lists.ozlabs.org>
To: Jens Axboe <axboe@fb.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <dc15451c-3c5e-1f61-f108-cea3c08332a9@fb.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 4, 2017 at 8:23 AM, Jens Axboe <axboe@fb.com> wrote:
> On 01/04/2017 08:28 AM, Theodore Ts'o wrote:
>>
>> Jens, could you expedite a pull request to Linus?  This is affecting
>> ext4 on 1k block file systems on x86/x86_64, so this is not a ppc-only
>> regression.
>
> Yes, it'll go out this morning.

It's merged and out there in my tree now.

                 Linus
